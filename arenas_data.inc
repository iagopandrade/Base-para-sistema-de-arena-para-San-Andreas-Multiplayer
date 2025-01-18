#define MAX_ARENAS 5
enum ArenaData
{
    Float:x,            // Coordenada X
    Float:y,            // Coordenada Y
    Float:z,            // Coordenada Z
    Float:rotation,     // Rota??o inicial
    virtualWorld,       // Mundo virtual
    interior,           // Interior
    name[32],         // Nome da Arena
	atalho[16],  // Atalho da arena
    maxPlayers,       // Limite de jogadores
    weaponList[10],    // Lista de armas permitidas (IDs)
	isConfigured
};
new g_Arenas[MAX_ARENAS][ArenaData];
new g_PlayerArena[MAX_PLAYERS];

stock InitializeArenas()
{
    // Area 51
    g_Arenas[0][x] = 177.1232;
    g_Arenas[0][y] = 2010.7736;
    g_Arenas[0][z] = 18.0724;
    g_Arenas[0][rotation] = 90.0;
    g_Arenas[0][virtualWorld] = 0;
    g_Arenas[0][interior] = 0;
    g_Arenas[0][maxPlayers] = 10; // Limite de jogadores
    strcpy(g_Arenas[0][name], "Area 51"); // Nome da arena
	strcpy(g_Arenas[0][atalho], "/a51");
    g_Arenas[0][weaponList][0] = 24; // Desert Eagle
    g_Arenas[0][weaponList][1] = 31; // M4
    g_Arenas[0][weaponList][2] = 34; // Sniper Rifl
	g_Arenas[0][isConfigured] = 1;
}
