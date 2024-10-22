window.addEventListener('message', function(event) {
    if (event.data.action == "showUI") {
        document.getElementById("coordsUI").style.display = "block";
        fetch(`https://kw_coords/getDiscordAvatar`, {
            method: 'POST'
        });
    } else if (event.data.action == "hideUI") {
        document.getElementById("coordsUI").style.display = "none";
    } else if (event.data.action == "updateCoords") {
        document.getElementById("coords").value = event.data.coords;
        document.getElementById("vector3").value = event.data.vector3;
        document.getElementById("vector4").value = event.data.vector4;
        document.getElementById("heading").value = event.data.heading;
    } else if (event.data.action == "updateAvatar") {
        document.getElementById('userAvatar').src = event.data.avatarURL;
    }
});

function copyText(elementId) {
    var copyText = document.getElementById(elementId);
    var input = document.createElement("input");
    input.setAttribute("value", copyText.value);
    document.body.appendChild(input);
    input.select();
    document.execCommand("copy");
    document.body.removeChild(input);

    fetch(`https://kw_coords/coordsCopied`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            message: "¡Coordenadas copiadas!"
        })
    });
}

function closeUI() {
    fetch(`https://kw_coords/closeUI`, {
        method: 'POST'
    });
}