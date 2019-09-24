enableSaving [ false, false];

if (isDedicated) then {debug_source = "Server";} else {debug_source = name player;};


// Initialise all shared scripts -- THIS SECTION EXECUTED ON ALL MACHINES
[] call compileFinal preprocessFileLineNumbers "scripts\shared\initialise_shared_script_library.sqf";





// If machine is server then call server initialisation scripts -- SERVER ONLY
if (isServer) then {
	[] call compileFinal preprocessFileLineNumbers "scripts\server\initialise_server.sqf";
};

// If machine is headless client then call headless client initialisation scripts -- HC ONLY
if (!isDedicated && !hasInterface && isMultiplayer) then {
	execVM "scripts\server\offloading\headless_client_manager.sqf";
};

// Finally, if the machine is a player machine then wait until the player spawns and initialise the client scripts -- PLAYER ONLY
if (!isDedicated && hasInterface) then {
	waitUntil {alive player};
	// reset the debug source name if necessary
	if (debug_source != name player) then {debug_source = name player;};
	[] call compileFinal preprocessFileLineNumbers "scripts\client\initialise_client.sqf";
} else { // if not then set the view distance to increase HC performance
	setViewDistance 1600;
};