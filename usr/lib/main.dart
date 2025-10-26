import 'package:flutter/material.dart';

void main() {
  runApp(const BYDEVControlApp());
}

class BYDEVControlApp extends StatelessWidget {
  const BYDEVControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BYD EV Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EVControlHomePage(),
    );
  }
}

class EVControlHomePage extends StatefulWidget {
  const EVControlHomePage({super.key});

  @override
  State<EVControlHomePage> createState() => _EVControlHomePageState();
}

class _EVControlHomePageState extends State<EVControlHomePage> {
  bool _isLocked = true;
  bool _isEngineOn = false;
  double _batteryLevel = 75.0; // Mock battery level
  bool _climateOn = false;
  double _temperature = 22.0;
  bool _isConnected = false; // Track connection status
  final TextEditingController _vinController = TextEditingController();

  void _toggleLock() {
    if (!_isConnected) return;
    setState(() {
      _isLocked = !_isLocked;
    });
    // Mock action: In real app, send command to EV
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isLocked ? 'Vehicle Locked' : 'Vehicle Unlocked')),
    );
  }

  void _toggleEngine() {
    if (!_isConnected) return;
    setState(() {
      _isEngineOn = !_isEngineOn;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEngineOn ? 'Engine Started' : 'Engine Stopped')),
    );
  }

  void _toggleClimate() {
    if (!_isConnected) return;
    setState(() {
      _climateOn = !_climateOn;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_climateOn ? 'Climate Control On' : 'Climate Control Off')),
    );
  }

  void _connectToVehicle() {
    final vin = _vinController.text.trim();
    if (vin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid VIN')),
      );
      return;
    }
    setState(() {
      _isConnected = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connected to Vehicle VIN: $vin')),
    );
  }

  @override
  void dispose() {
    _vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BYD EV Control'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // VIN Connection Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Connect to Vehicle',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _vinController,
                      decoration: const InputDecoration(
                        labelText: 'Enter VIN Number',
                        hintText: 'e.g., 1HGBH41JXMN109186',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !_isConnected,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _isConnected ? null : _connectToVehicle,
                            child: Text(_isConnected ? 'Connected' : 'Connect'),
                          ),
                        ),
                        if (_isConnected) ...[
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isConnected = false;
                                _vinController.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Disconnected from Vehicle')),
                              );
                            },
                            child: const Text('Disconnect'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Battery Status
            if (_isConnected) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Battery Level',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _batteryLevel / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _batteryLevel > 20 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('${_batteryLevel.toInt()}%', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            // Control Buttons
            if (_isConnected)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleLock,
                      icon: Icon(_isLocked ? Icons.lock : Icons.lock_open),
                      label: Text(_isLocked ? 'Lock' : 'Unlock'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleEngine,
                      icon: Icon(_isEngineOn ? Icons.power : Icons.power_off),
                      label: Text(_isEngineOn ? 'Stop Engine' : 'Start Engine'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleClimate,
                      icon: Icon(_climateOn ? Icons.ac_unit : Icons.wb_sunny),
                      label: Text(_climateOn ? 'Climate Off' : 'Climate On'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Mock location
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vehicle Location: Parking Lot A')),
                        );
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text('Find Vehicle'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                  ],
                ),
              ),
            // Temperature Slider (if climate is on and connected)
            if (_isConnected && _climateOn) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Cabin Temperature: ${_temperature.toInt()}°C',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Slider(
                        value: _temperature,
                        min: 16,
                        max: 28,
                        divisions: 12,
                        label: '${_temperature.toInt()}°C',
                        onChanged: (value) {
                          setState(() {
                            _temperature = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}