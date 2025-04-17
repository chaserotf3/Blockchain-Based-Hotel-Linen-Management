# Blockchain-Based Hotel Linen Management

This repository contains a decentralized solution for managing hotel linen inventory using blockchain technology. The system provides transparent tracking, efficient processing, and cost management for hotel textiles throughout their lifecycle.

## Core Components

The platform consists of four primary smart contracts:

1. **Inventory Registration Contract**: Tokenizes and tracks all hotel textiles including sheets, towels, tablecloths, and uniforms
2. **Laundry Tracking Contract**: Records cleaning cycles, detergent usage, and processing times for all linen items
3. **Replacement Scheduling Contract**: Manages the lifecycle of textiles and automates the retirement process based on usage
4. **Cost Allocation Contract**: Distributes linen-related expenses across different hotel departments and cost centers

## Features

- Digital twin representation of physical linen assets
- Real-time tracking of linen location and status
- Automated monitoring of cleaning cycles and quality control
- Usage-based replacement scheduling for optimal inventory management
- Transparent cost allocation for accurate departmental budgeting
- PAR level maintenance through predictive analytics
- Theft and loss reduction through improved accountability
- Integration with RFID/NFC technology for automated tracking

## Getting Started

### Prerequisites

- Node.js and npm
- Truffle or Hardhat development framework
- Ethereum wallet (MetaMask recommended)
- RFID/NFC hardware (optional but recommended)

### Installation

1. Clone the repository
```
git clone https://github.com/your-username/hotel-linen-management.git
cd hotel-linen-management
```

2. Install dependencies
```
npm install
```

3. Compile smart contracts
```
npx truffle compile
```

4. Deploy to your preferred network
```
npx truffle migrate --network [network-name]
```

## Usage

The platform supports the complete hotel linen management workflow:

1. Register new linen items with specific attributes (type, size, material, quality)
2. Track linen movement between rooms, laundry, and storage
3. Monitor wash cycles and processing conditions
4. Schedule replacements based on usage data and condition assessments
5. Generate reports for cost allocation and inventory management

## Benefits

- Reduced linen replacement costs through optimal lifecycle management
- Enhanced operational efficiency in housekeeping and laundry operations
- Improved guest experience through consistent linen quality
- Data-driven procurement decisions
- Environmental sustainability through optimized washing procedures
- Accurate departmental cost attribution

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
