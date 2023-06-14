let onlineCount = `<span id="onlineCount">发生错误, 请联系CnRoma: 1416984414</span>`;
let container = document.getElementById('container-id');
let gameState = false

function joinGame() {
    $.post("https://peekaboo/tryJoinGame");
    setPlayerButtonState(false);
}

function quitGame() {
    $.post("https://peekaboo/quitGame");
    setPlayerButtonState(true)
}

function showMenu(state) {
    container.style.display = 'block';
    if (state) {
        setPlayerButtonState(state);
    }
}

function hideMenu() {
    container.style.display = 'none';
    $.post("https://peekaboo/hideMenu", JSON.stringify({hide: true}));
}

function syncPlayerCount(count, state) {
    if (count >= 0) {
        onlineCount = `<span id="onlineCount">${count}</span>`;
        document.getElementById('onlineCount').innerHTML = onlineCount;
    }
    if (state) {
        setPlayerButtonState(state);
    }
    document.getElementById('onlineCount').innerHTML = onlineCount;
}

window.addEventListener('message', function (event) {
    // event.data.action: 'show', 'hide'
    // event.data.playerCount: int
    let data = event.data;
    if (data != undefined && data.action != undefined) {
        if (data.action == 'show') {
            showMenu(data.playerState);
            syncPlayerCount(data.playerCount, data.playerState);
        }
        else if (data.action == 'hide') {
            hideMenu();
        }
        else if (data.action == 'update') {
            syncPlayerCount(data.playerCount, data.playerState);
        }
        else if (data.action == 'start') {
            gameState = data.gameState;
        }
        else
            console.log('[躲猫猫]: 发生错误, 无效的event.data.action');
    }
    else {
        console.log('[躲猫猫]: 发生错误, 无效的event事件参数');
    }
});

function setPlayerButtonState(state) {
    if (state) {
        document.getElementById('join-button-id').onclick = joinGame;
        document.getElementById('join-button-id').innerText = '加入游戏';
    }
    else {
        if (gameState) return;
        document.getElementById('join-button-id').onclick = quitGame;
        document.getElementById('join-button-id').innerText = '退出游戏';
    }
}