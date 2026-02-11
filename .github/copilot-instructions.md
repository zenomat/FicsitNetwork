# Copilot Instructions for Satisfactory Lua Control Systems

## Project Overview
This is a Lua codebase for the Satisfactory game that implements distributed factory monitoring and control systems. Multiple computers (clients) manage specific factory components and communicate with a central server via network cards to display aggregated factory data.

## Architecture Pattern
- **Modular Structure**: Each factory/system (Manufacturing, AlumFactory, UraniumPowerPlant, Server) has isolated folders
- **Component Initialization**: Every system starts with `InitComponents.lua` which uses `component.proxy()` and `component.findComponent()` to locate and bind to Satisfactory game objects
- **File Loading Pattern**: Systems load additional modules via `filesystem.doFile()` or HTTP requests
- **Global State Model**: All proxies and game component references stored as global variables (no local encapsulation)

## Key Technical Patterns

### Component Discovery & Binding
```lua
-- Pattern used throughout codebase:
gpu = computer.getPCIDevices(classes.GPUT1)[1]
screen = component.proxy(component.findComponent("Screen1")[1])
storage = component.proxy(component.findComponent("Storage1")[1])
```

### File Loading Methods
1. **Local Filesystem** (AlumFactory, Manufacturing local): Mount `/dev` and load via `filesystem.doFile()`
2. **HTTP from Server** (Manufacturing remote): Use Internet Card to request files from HTTP server at `192.168.10.106` or `localhost`
3. **Direct Embedding** (MainCodeToLoadFiles): Entry point scripts that coordinate loading

### Network Communication (Peer-to-Peer)
- **Port-based routing**: Each manufacturing system opens specific ports (1112-1122 for different machine types, 3000+ for test/custom)
- **Message format**: Pipe-delimited strings like `"Crystal|Ok|NotOk|Ok|996|Off"` (name|man1_status|man2_status|man3_status|quantity|on_off)
- **Server receives**: Uses `event.listen(netcard)` and `event.pull()` to wait for network messages on open ports
- **Clients send**: `netcard:send(receiverNetCard, PortToServer, netSendMsg)`

### Screen/Display Management
- Bind GPU to screen: `gpu:bindScreen(screen)`
- Render with `gpu:setText(x, y, message)` and `gpu:flush()`
- Color system: RGBA tuples like `gpu:setForeground(1, 0, 0, 1)` for red
- Common grid patterns: 18-char names, 6-char status columns, 10-char quantity

### Data Flow
1. Client reads inventory/status from storage containers and machines
2. Client formats message with machine status and quantities
3. Client sends via network to server on specific port
4. Server receives, parses pipe-delimited string, displays on screen
5. Server sends overhead sign text to factory via component proxy

## Development Workflows

### Adding a New Factory System
1. Create folder: `NewFactory/`
2. Add `InitComponents.lua` with component discovery for your machines
3. Add `MainLoop.lua` with main event loop (typically: read sensors, format data, send/display, check timeouts)
4. Link in global variables file if using server communication

### Modifying Display Output
- Screen resolution available via `gpu:getSize()` (usually 150x50)
- Use `ShowMsg(x, y, message, color)` helper (defined in ScreenFunctions.lua)
- Test locally before deploying; use `ScreenTimeout.lua` pattern to auto-hide display

### Testing Network Messages
- Server must call `netcard:open(PORT)` to listen
- Client must know exact receiver NetCard ID (stored as variable, e.g., `receiverNetCard = "...ID..."`
- Use `event.pull(timeout)` with timeout to prevent blocking

## Project-Specific Conventions
- **DebugMode**: Passed to most `Initialization()` functions; wraps print statements
- **Global Variable Pattern**: All components proxies are globals (e.g., `FuelRodStorage`, `Reactor1`), no local scoping to functions
- **PrintDebugInfo()**: Consistent debug helper; check entire codebase for usage before changing
- **Naming**: PascalCase for components, snake_case avoided; explicit names like `FuelRef1`, `WaterTankReactor`
- **No version control integration**: Code stored in Windows SaveGames folder; HTTP server used for distribution
- **Screen Coordinate System**: Top-left is (1,1); rows typically 1-indexed starting from status line

## Common Integration Points
- **StorageContainer API**: `.getInventories()` → `.getStack(index)` → read item counts
- **Manufacturer API**: Check `.getProductivity()` for status, inventory for raw/output counts
- **PowerInfo/Circuit API**: `getPowerConnectors()` → `.getCircuit()` → read consumption/capacity/battery values
- **ModularIndicatorPole**: Get via `component.proxy(component.findComponent("ModularIndicatorPole")[1])`
- **Sign/Display Data**: Use `getModule()`, `getPrefabSignData()`, `setTextElement()`, `setPrefabSignData()` for overhead signs

## Critical Files for Context
- [Manufacturing/MAIN_CODE](Manufacturing/MAIN_CODE) - Best example of HTTP-based distributed client
- [Server/Server.lua](Server/Server.lua) - Aggregation server with network parsing
- [CommonFunctions/StorageContainerInfo.lua](CommonFunctions/StorageContainerInfo.lua) - Inventory reading patterns
- [Manufacturing/NetSend.lua](Manufacturing/NetSend.lua) - Message formatting convention

## Common Gotchas
- Network cards must have matching UIDs on both sender and receiver
- `event.pull(0)` will not block; use `event.pull(1)` or higher timeout
- Components stored in variables may become stale; consider re-proxying if behavior changes
- HTTP server paths are hardcoded; update all clients if server IP changes
- Screen can show coordinates outside visible range without error; causes mysterious display issues
