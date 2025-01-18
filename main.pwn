#include <open.mp>
#include <sscanf2>
#include <zcmd>

// Data
#include <arenas_data>

public OnGameModeInit()
{
	InitializeArenas(); // Configura os dados das arenas
	return 1;
}

public OnGameModeExit()
{
    return 1;
}

public OnPlayerSpawn(playerid)
{
	g_PlayerArena[playerid] = -1;
	return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
	return 1;
}

// Comandos
CMD:arenas(playerid)
{
    ShowArenaInfoDialog(playerid);
    return 1;
}

CMD:a51(playerid)
{
	// Funcao para colocar o jogador em uma arena
	// A funcao esta configurada para a arena id 0 
	SetPlayerArena(playerid, 0);
	return 1;
}

CMD:sairarena(playerid, params[])
{
    // Verificar se o jogador esta em uma arena
    if (g_PlayerArena[playerid] == -1)
    {
        SendClientMessage(playerid, -1, "Voce nao esta em nenhuma arena para sair.");
        return 1;
    }

    // Obter o ID da arena em que o jogador esta
    new arenaID = g_PlayerArena[playerid];
	// Funcao para remover o jogador de uma arena
    RemovePlayerFromArena(playerid, arenaID);
    return 1;
}

// Fun?oes
#define DIALOG_ARENAS 0
#define DIALOG_INFORMACOES_ARENAS 1

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_ARENAS)
    {
        if (response)
        {
            switch(listitem)
            {
                case 0: cmd_a51(playerid);
            }
        }
        return 1;
    }
	printf( "playerid = %d, dialogid = YOUR_DIALOGID, response = %d, listitem = %d, inputtext = '%s' (size: %d)", playerid, response, listitem, inputtext, strlen( inputtext ) );
    return 0;
}

// Funcao para colocar o jogador em uma arena
stock SetPlayerArena(playerid, arenaID)
{
    if (arenaID < 0 || arenaID >= MAX_ARENAS) 
        return 0; // Validacao de ID de arena

	// Verificar se o jogador ja esta na arena
	if (g_PlayerArena[playerid] == arenaID)
		return SendClientMessage(playerid, -1, "Voce ja esta nessa arena.");
		
    // Atribui o jogador a arena
    g_PlayerArena[playerid] = arenaID;

    // Define as coordenadas e a virtual world da arena
    SetPlayerPos(playerid, g_Arenas[arenaID][x], g_Arenas[arenaID][y], g_Arenas[arenaID][z]);
    SetPlayerVirtualWorld(playerid, g_Arenas[arenaID][virtualWorld]);
    SetPlayerInterior(playerid, g_Arenas[arenaID][interior]);

    // Mensagem global
    new message[128];
    format(message, sizeof(message), "%s entrou na arena: %s (%d/%d).", 
        GetPlayerNameEx(playerid), g_Arenas[arenaID][name], CountPlayersInArena(arenaID), g_Arenas[arenaID][maxPlayers]);
    SendClientMessageToAll(-1, message); 

    return 1;
}

// Funcao para remover o jogador de uma arena
stock RemovePlayerFromArena(playerid, arenaID)
{
    if (arenaID < 0 || arenaID >= MAX_ARENAS) return 0; // Validacao

    new arenaid = g_PlayerArena[playerid];
    g_PlayerArena[playerid] = -1; // Reset da arena do jogador

    // Mensagem global
    new message[128];
    format(message, sizeof(message), "%s saiu da arena: %s (%d/%d).", 
        GetPlayerNameEx(playerid), g_Arenas[arenaid][name], CountPlayersInArena(arenaid), g_Arenas[arenaid][maxPlayers]);
    SendClientMessageToAll(-1, message);

    // Reseta algumas configuracoes do jogador
	SetPlayerPos(playerid, 0.0, 0.0, 0.0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SendClientMessage(playerid, -1, "Voce saiu da arena.");
    return 1;
}

// Funcao para verificar e exibir a dialog de arenas
stock ShowArenaInfoDialog(playerid)
{
    new string[1024]; // Tamanho suficiente para multiplas arenas
    new temp[128];    // Usado para formatar cada linha

    // Adicionar cabecalhos ao dialog (nome, atalho, players)
    format(string, sizeof(string), "Arena\tAtalho\tPlayers\n");

    // Preencher com informacoes especificas das arenas
    for (new i = 0; i < MAX_ARENAS; i++)
    {
        // Verifica se a arena foi configurada corretamente
        if (g_Arenas[i][isConfigured] == 0) 
            continue;  // Pula para a proxima arena se esta n?o estiver configurada

        // Obter dados da arena
        new currentPlayers = CountPlayersInArena(i);
        new arenaMaxPlayers = g_Arenas[i][maxPlayers]; // Usando nome diferente para evitar conflito

        // Verifica se o limite de jogadores foi configurado corretamente
        if (arenaMaxPlayers <= 0) 
            arenaMaxPlayers = 1;  // Caso o valor do limite seja invalido, substituimos por 1

        // Adicionar informa??es da arena (nome, atalho, players)
        format(temp, sizeof(temp), "%s\t%s\t%d/%d\n", 
            g_Arenas[i][name], g_Arenas[i][atalho], currentPlayers, arenaMaxPlayers);
        strcat(string, temp, sizeof(string));
    }

    // Verifica se ha alguma arena para exibir
    if (strlen(string) <= strlen("Arena\tAtalho\tPlayers\n"))
    {
        SendClientMessage(playerid, -1, "Nao ha arenas configuradas no momento.");
        return 1;
    }

    // Exibir o dialog com as informacoes formatadas
    ShowPlayerDialog(playerid, DIALOG_ARENAS, DIALOG_STYLE_TABLIST_HEADERS, 
        "Arenas Deadmatch", string, "Selecionar", "Cancelar");

    return 1;
}

// Funcao para calcular a quantidade jogadores em uma arena
stock CountPlayersInArena(arenaID)
{
    new count = 0;
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i) && g_PlayerArena[i] == arenaID)
        {
            count++;
        }
    }
    return count;
}

// Funcao para pegar o nome de um jogador
stock GetPlayerNameEx(playerid)
{
	new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	return PlayerName;
}
