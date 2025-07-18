# Week 3 Linux Lab: Risk Management Fundamentals
## Student Lab Manual

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
**Course: GRC101 - Introduction to Governance, Risk, and Compliance**  
**Lab Duration: 3 hours**  
**Difficulty Level: Intermediate to Advanced**

---

## Lab Overview

Welcome to the Risk Management Fundamentals lab! In this hands-on session, you will learn to implement enterprise risk management using Linux tools and methodologies. You'll create automated risk assessment systems, implement continuous risk monitoring, develop risk quantification models, and build comprehensive risk reporting dashboards.

This lab will give you practical experience with modern risk management frameworks including NIST RMF, ISO 31000, and FAIR (Factor Analysis of Information Risk) using real Linux environments and tools.

### What You Will Learn

By the end of this lab, you will be able to:
1. Build automated risk assessment and identification systems
2. Implement continuous risk monitoring using Linux tools
3. Create risk quantification models and calculations
4. Develop risk dashboards and reporting mechanisms
5. Integrate threat intelligence for enhanced risk assessment
6. Understand how Linux supports enterprise risk management
7. Create risk response and mitigation tracking systems

### Prerequisites

- Completion of Week 1 and Week 2 Linux Labs
- Understanding of risk management frameworks from course readings
- Intermediate Linux command-line skills
- Basic knowledge of statistics and probability
- Familiarity with network security and system monitoring concepts

---

## Lab Environment Setup

### Required Software Installation

Before starting the exercises, you need to install the required tools and libraries. Follow these steps carefully:

```bash
# Update your system
sudo apt update && sudo apt upgrade -y

# Install Python and data analysis libraries
sudo apt install -y python3 python3-pip python3-venv
pip3 install pandas numpy matplotlib scipy seaborn plotly

# Install database systems
sudo apt install -y sqlite3 mysql-server postgresql

# Install network and system monitoring tools
sudo apt install -y nmap netstat-nat ss htop iotop vmstat sysstat

# Install statistical and analysis tools
sudo apt install -y r-base gnuplot bc

# Install additional utilities for data processing
sudo apt install -y jq xmlstarlet csvkit curl wget

# Verify installations
python3 --version
sqlite3 --version
nmap --version
```

### Create Lab Directory Structure

Set up the directory structure for your risk management lab:

```bash
# Create main risk management directory
sudo mkdir -p /opt/risk_management/{assessment,monitoring,quantification,reporting,intelligence}
sudo mkdir -p /opt/risk_management/assessment/{identification,analysis,evaluation,treatment}
sudo mkdir -p /opt/risk_management/monitoring/{continuous,periodic,event_driven}
sudo mkdir -p /opt/risk_management/data/{assets,threats,vulnerabilities,controls,database}
sudo mkdir -p /opt/risk_management/scripts

# Set up proper permissions
sudo chown -R $USER:$USER /opt/risk_management
chmod -R 755 /opt/risk_management

# Create log directories
mkdir -p /opt/risk_management/{assessment,monitoring,intelligence}/logs
```

---

## Exercise 1: Risk Assessment Framework Implementation

### Objective
Create a comprehensive risk assessment framework using Linux tools that can automatically identify, analyze, and prioritize risks across your organization's assets.

### Background
Risk assessment is the foundation of any effective risk management program. In this exercise, you'll build a system that can:
- Store and manage asset, threat, and vulnerability information
- Calculate risk scores using standardized methodologies
- Generate comprehensive risk assessments and reports
- Track risk treatments and mitigation efforts

### Step 1: Create the Risk Management Database

First, you'll create a SQLite database to store all risk-related information:

```bash
# Navigate to the database directory
cd /opt/risk_management/data/database

# Create the risk management database
sqlite3 risk_management.db << 'EOF'
-- Create Assets table
CREATE TABLE IF NOT EXISTS assets (
    asset_id TEXT PRIMARY KEY,
    asset_name TEXT NOT NULL,
    asset_type TEXT NOT NULL,
    business_value INTEGER NOT NULL,
    criticality TEXT NOT NULL,
    owner TEXT NOT NULL,
    location TEXT,
    description TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Threats table
CREATE TABLE IF NOT EXISTS threats (
    threat_id TEXT PRIMARY KEY,
    threat_name TEXT NOT NULL,
    threat_type TEXT NOT NULL,
    threat_source TEXT NOT NULL,
    likelihood INTEGER NOT NULL,
    description TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Vulnerabilities table
CREATE TABLE IF NOT EXISTS vulnerabilities (
    vuln_id TEXT PRIMARY KEY,
    vuln_name TEXT NOT NULL,
    vuln_type TEXT NOT NULL,
    severity INTEGER NOT NULL,
    cvss_score REAL,
    affected_assets TEXT,
    description TEXT,
    remediation TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Risk Assessments table
CREATE TABLE IF NOT EXISTS risk_assessments (
    assessment_id TEXT PRIMARY KEY,
    asset_id TEXT NOT NULL,
    threat_id TEXT NOT NULL,
    vuln_id TEXT,
    likelihood INTEGER NOT NULL,
    impact INTEGER NOT NULL,
    risk_score INTEGER NOT NULL,
    risk_level TEXT NOT NULL,
    assessment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    assessor TEXT NOT NULL,
    status TEXT DEFAULT 'ACTIVE',
    FOREIGN KEY (asset_id) REFERENCES assets (asset_id),
    FOREIGN KEY (threat_id) REFERENCES threats (threat_id),
    FOREIGN KEY (vuln_id) REFERENCES vulnerabilities (vuln_id)
);

-- Create Risk Treatments table
CREATE TABLE IF NOT EXISTS risk_treatments (
    treatment_id TEXT PRIMARY KEY,
    assessment_id TEXT NOT NULL,
    treatment_type TEXT NOT NULL,
    treatment_description TEXT NOT NULL,
    implementation_date DATE,
    responsible_party TEXT,
    cost REAL,
    effectiveness INTEGER,
    status TEXT DEFAULT 'PLANNED',
    FOREIGN KEY (assessment_id) REFERENCES risk_assessments (assessment_id)
);

-- Insert sample data for testing
INSERT INTO assets VALUES 
('AST_001', 'Web Server', 'Server', 8, 'HIGH', 'IT Team', 'Data Center', 'Primary web application server', datetime('now'), datetime('now')),
('AST_002', 'Database Server', 'Database', 9, 'CRITICAL', 'DBA Team', 'Data Center', 'Customer database server', datetime('now'), datetime('now')),
('AST_003', 'Workstation', 'Endpoint', 5, 'MEDIUM', 'User', 'Office', 'Employee workstation', datetime('now'), datetime('now')),
('AST_004', 'File Server', 'Server', 7, 'HIGH', 'IT Team', 'Data Center', 'Document storage server', datetime('now'), datetime('now'));

INSERT INTO threats VALUES 
('THR_001', 'Malware Attack', 'Cyber', 'External', 7, 'Malicious software targeting systems', datetime('now'), datetime('now')),
('THR_002', 'Insider Threat', 'Human', 'Internal', 4, 'Malicious or negligent insider actions', datetime('now'), datetime('now')),
('THR_003', 'DDoS Attack', 'Cyber', 'External', 6, 'Distributed denial of service attack', datetime('now'), datetime('now')),
('THR_004', 'Data Breach', 'Cyber', 'External', 8, 'Unauthorized access to sensitive data', datetime('now'), datetime('now'));

INSERT INTO vulnerabilities VALUES 
('VUL_001', 'Unpatched Software', 'Technical', 8, 7.5, 'AST_001,AST_003', 'Missing security patches', 'Apply security updates', datetime('now'), datetime('now')),
('VUL_002', 'Weak Passwords', 'Human', 6, 5.0, 'AST_001,AST_002,AST_003', 'Inadequate password policies', 'Implement strong password policy', datetime('now'), datetime('now')),
('VUL_003', 'Network Exposure', 'Technical', 7, 6.8, 'AST_001,AST_002', 'Unnecessary network services', 'Implement network segmentation', datetime('now'), datetime('now')),
('VUL_004', 'Lack of Encryption', 'Technical', 9, 8.2, 'AST_002,AST_004', 'Data stored without encryption', 'Implement data encryption', datetime('now'), datetime('now'));

EOF

echo "Risk management database created successfully!"
```

### Step 2: Create the Risk Assessment Engine

Now you'll create a script that can perform automated risk assessments:

```bash
# Create the risk assessment engine script
cat > /opt/risk_management/scripts/risk_assessment_engine.sh << 'EOF'
#!/bin/bash
# Automated Risk Assessment Engine

RISK_BASE="/opt/risk_management"
DB_FILE="$RISK_BASE/data/database/risk_management.db"
ASSESSMENT_LOG="$RISK_BASE/assessment/logs/assessment.log"
REPORTS_DIR="$RISK_BASE/reporting/assessments"

mkdir -p "$(dirname "$ASSESSMENT_LOG")"
mkdir -p "$REPORTS_DIR"

# Function to calculate risk score
calculate_risk_score() {
    local likelihood=$1
    local impact=$2
    
    # Risk Score = Likelihood × Impact
    local risk_score=$((likelihood * impact))
    
    echo "$risk_score"
}

# Function to determine risk level
determine_risk_level() {
    local risk_score=$1
    
    if [ "$risk_score" -ge 64 ]; then
        echo "CRITICAL"
    elif [ "$risk_score" -ge 36 ]; then
        echo "HIGH"
    elif [ "$risk_score" -ge 16 ]; then
        echo "MEDIUM"
    elif [ "$risk_score" -ge 4 ]; then
        echo "LOW"
    else
        echo "MINIMAL"
    fi
}

# Function to perform risk assessment
perform_risk_assessment() {
    local asset_id=$1
    local threat_id=$2
    local vuln_id=$3
    local likelihood=$4
    local impact=$5
    local assessor=$6
    
    local assessment_id="ASSESS_$(date +%Y%m%d_%H%M%S)_$$"
    local risk_score=$(calculate_risk_score "$likelihood" "$impact")
    local risk_level=$(determine_risk_level "$risk_score")
    
    echo "$(date): Performing risk assessment $assessment_id" >> "$ASSESSMENT_LOG"
    echo "Asset: $asset_id, Threat: $threat_id, Vulnerability: $vuln_id" >> "$ASSESSMENT_LOG"
    echo "Likelihood: $likelihood, Impact: $impact, Risk Score: $risk_score, Risk Level: $risk_level" >> "$ASSESSMENT_LOG"
    
    # Insert assessment into database
    sqlite3 "$DB_FILE" << EOSQL
INSERT INTO risk_assessments (
    assessment_id, asset_id, threat_id, vuln_id, 
    likelihood, impact, risk_score, risk_level, assessor
) VALUES (
    '$assessment_id', '$asset_id', '$threat_id', '$vuln_id',
    $likelihood, $impact, $risk_score, '$risk_level', '$assessor'
);
EOSQL

    if [ $? -eq 0 ]; then
        echo "Risk assessment completed: $assessment_id"
        echo "Risk Score: $risk_score ($risk_level)"
        
        # Generate individual assessment report
        generate_assessment_report "$assessment_id"
        
        return 0
    else
        echo "Error: Failed to save risk assessment"
        return 1
    fi
}

# Function to generate assessment report
generate_assessment_report() {
    local assessment_id=$1
    local report_file="$REPORTS_DIR/assessment_report_$assessment_id.txt"
    
    # Create detailed assessment report
    cat > "$report_file" << EOREPORT
========================================
RISK ASSESSMENT REPORT
========================================

Assessment ID: $assessment_id
Generated: $(date)

ASSET INFORMATION:
$(sqlite3 "$DB_FILE" "
SELECT 'Asset ID: ' || a.asset_id || char(10) ||
       'Asset Name: ' || a.asset_name || char(10) ||
       'Asset Type: ' || a.asset_type || char(10) ||
       'Business Value: ' || a.business_value || char(10) ||
       'Criticality: ' || a.criticality || char(10) ||
       'Owner: ' || a.owner
FROM risk_assessments ra
JOIN assets a ON ra.asset_id = a.asset_id
WHERE ra.assessment_id = '$assessment_id';
")

THREAT INFORMATION:
$(sqlite3 "$DB_FILE" "
SELECT 'Threat ID: ' || t.threat_id || char(10) ||
       'Threat Name: ' || t.threat_name || char(10) ||
       'Threat Type: ' || t.threat_type || char(10) ||
       'Threat Source: ' || t.threat_source || char(10) ||
       'Base Likelihood: ' || t.likelihood
FROM risk_assessments ra
JOIN threats t ON ra.threat_id = t.threat_id
WHERE ra.assessment_id = '$assessment_id';
")

VULNERABILITY INFORMATION:
$(sqlite3 "$DB_FILE" "
SELECT CASE 
    WHEN v.vuln_id IS NOT NULL THEN
        'Vulnerability ID: ' || v.vuln_id || char(10) ||
        'Vulnerability Name: ' || v.vuln_name || char(10) ||
        'Vulnerability Type: ' || v.vuln_type || char(10) ||
        'Severity: ' || v.severity || char(10) ||
        'CVSS Score: ' || COALESCE(v.cvss_score, 'N/A')
    ELSE 'No specific vulnerability identified'
END
FROM risk_assessments ra
LEFT JOIN vulnerabilities v ON ra.vuln_id = v.vuln_id
WHERE ra.assessment_id = '$assessment_id';
")

RISK ANALYSIS:
$(sqlite3 "$DB_FILE" "
SELECT 'Likelihood: ' || ra.likelihood || char(10) ||
       'Impact: ' || ra.impact || char(10) ||
       'Risk Score: ' || ra.risk_score || char(10) ||
       'Risk Level: ' || ra.risk_level || char(10) ||
       'Assessor: ' || ra.assessor || char(10) ||
       'Assessment Date: ' || ra.assessment_date
FROM risk_assessments ra
WHERE ra.assessment_id = '$assessment_id';
")

RECOMMENDATIONS:
- Review and validate the risk assessment results
- Consider implementing additional controls if risk level is HIGH or CRITICAL
- Monitor the risk scenario for changes in likelihood or impact
- Document any risk treatment decisions
- Schedule regular reassessment based on risk level

========================================
EOREPORT

    echo "Assessment report generated: $report_file"
}

# Function to generate risk register
generate_risk_register() {
    local register_file="$REPORTS_DIR/risk_register_$(date +%Y%m%d_%H%M%S).csv"
    
    sqlite3 "$DB_FILE" << EOSQL
.mode csv
.headers on
.output '$register_file'

SELECT 
    ra.assessment_id,
    a.asset_name,
    t.threat_name,
    COALESCE(v.vuln_name, 'N/A') as vulnerability,
    ra.likelihood,
    ra.impact,
    ra.risk_score,
    ra.risk_level,
    ra.assessment_date,
    ra.assessor,
    ra.status
FROM risk_assessments ra
JOIN assets a ON ra.asset_id = a.asset_id
JOIN threats t ON ra.threat_id = t.threat_id
LEFT JOIN vulnerabilities v ON ra.vuln_id = v.vuln_id
ORDER BY ra.risk_score DESC;

EOSQL

    echo "Risk register generated: $register_file"
}

# Main script logic
case "$1" in
    "assess")
        if [ $# -ne 7 ]; then
            echo "Usage: $0 assess <asset_id> <threat_id> <vuln_id> <likelihood> <impact> <assessor>"
            echo "Example: $0 assess AST_001 THR_001 VUL_001 7 8 'John Doe'"
            exit 1
        fi
        perform_risk_assessment "$2" "$3" "$4" "$5" "$6" "$7"
        ;;
    "register")
        generate_risk_register
        ;;
    "report")
        if [ $# -ne 2 ]; then
            echo "Usage: $0 report <assessment_id>"
            exit 1
        fi
        generate_assessment_report "$2"
        ;;
    *)
        echo "Usage: $0 {assess|register|report} [arguments]"
        echo "  assess: Perform individual risk assessment"
        echo "  register: Generate comprehensive risk register"
        echo "  report: Generate individual assessment report"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x /opt/risk_management/scripts/risk_assessment_engine.sh
```

### Step 3: Perform Risk Assessments

Now let's perform some risk assessments using your new system:

```bash
# Navigate to the scripts directory
cd /opt/risk_management/scripts

# Perform several risk assessments
echo "Performing risk assessments..."

# High-risk scenario: Database server + Data breach + Lack of encryption
./risk_assessment_engine.sh assess AST_002 THR_004 VUL_004 8 9 "$(whoami)"

# Medium-risk scenario: Web server + Malware + Unpatched software
./risk_assessment_engine.sh assess AST_001 THR_001 VUL_001 7 6 "$(whoami)"

# Lower-risk scenario: Workstation + Insider threat + Weak passwords
./risk_assessment_engine.sh assess AST_003 THR_002 VUL_002 4 5 "$(whoami)"

# Another high-risk scenario: File server + Data breach + Lack of encryption
./risk_assessment_engine.sh assess AST_004 THR_004 VUL_004 7 8 "$(whoami)"

echo "Risk assessments completed!"
```

### Step 4: Generate Risk Register

Create a comprehensive risk register showing all your assessments:

```bash
# Generate the risk register
./risk_assessment_engine.sh register

# View the risk register
echo "=== RISK REGISTER ==="
latest_register=$(ls -t /opt/risk_management/reporting/assessments/risk_register_*.csv | head -1)
cat "$latest_register"
```

### Questions for Exercise 1:

1. **Database Design**: Why is it important to separate assets, threats, and vulnerabilities into different tables?

2. **Risk Scoring**: How does the risk score calculation (Likelihood × Impact) help prioritize risks?

3. **Risk Levels**: What actions would you recommend for each risk level (CRITICAL, HIGH, MEDIUM, LOW)?

4. **Assessment Quality**: What factors could affect the accuracy of your risk assessments?

---

## Exercise 2: Continuous Risk Monitoring Implementation

### Objective
Implement a continuous risk monitoring system that can detect changes in your environment and automatically update risk assessments based on real-time data.

### Background
Modern risk management requires continuous monitoring rather than periodic assessments. In this exercise, you'll build systems that monitor:
- System vulnerabilities and security updates
- Network risks and suspicious activities
- Asset performance and availability
- Threat intelligence feeds

### Step 1: Create the Continuous Monitoring System

```bash
# Create the continuous monitoring script
cat > /opt/risk_management/scripts/continuous_monitoring.sh << 'EOF'
#!/bin/bash
# Continuous Risk Monitoring System

RISK_BASE="/opt/risk_management"
MONITORING_DIR="$RISK_BASE/monitoring"
LOG_DIR="$MONITORING_DIR/logs"
DATA_DIR="$MONITORING_DIR/data"
ALERTS_DIR="$MONITORING_DIR/alerts"

mkdir -p "$LOG_DIR" "$DATA_DIR" "$ALERTS_DIR"

# Function to monitor system vulnerabilities
monitor_system_vulnerabilities() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local vuln_log="$LOG_DIR/vulnerability_monitoring.log"
    local vuln_data="$DATA_DIR/current_vulnerabilities.json"
    
    echo "$timestamp: Starting vulnerability monitoring" >> "$vuln_log"
    
    # Check for available security updates
    local security_updates=$(apt list --upgradable 2>/dev/null | grep -i security | wc -l)
    
    # Check for running services
    local running_services=$(systemctl list-units --type=service --state=running | grep -E "(apache|nginx|mysql|ssh)" | wc -l)
    
    # Check for open ports
    local open_ports=$(ss -tuln | grep LISTEN | wc -l)
    
    # Check for failed login attempts (last hour)
    local failed_logins=$(grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date +%b\ %d)" | wc -l)
    
    # Create vulnerability data in JSON format
    cat > "$vuln_data" << EOJSON
{
    "timestamp": "$timestamp",
    "security_updates": $security_updates,
    "running_services": $running_services,
    "open_ports": $open_ports,
    "failed_logins": $failed_logins,
    "system": "$(hostname)",
    "monitoring_status": "active"
}
EOJSON

    # Calculate vulnerability risk score
    local vuln_risk_score=$((security_updates * 2 + failed_logins + open_ports / 2))
    
    # Log vulnerability assessment
    echo "$timestamp|VULN_ASSESSMENT|Score:$vuln_risk_score|Updates:$security_updates|Services:$running_services|Ports:$open_ports|FailedLogins:$failed_logins" >> "$vuln_log"
    
    # Generate alert if high risk
    if [ "$vuln_risk_score" -gt 15 ]; then
        generate_risk_alert "VULNERABILITY" "HIGH" "System vulnerability risk score: $vuln_risk_score" "$vuln_data"
    fi
    
    echo "Vulnerability monitoring completed. Risk score: $vuln_risk_score"
}

# Function to monitor network risks
monitor_network_risks() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local network_log="$LOG_DIR/network_monitoring.log"
    local network_data="$DATA_DIR/current_network_status.json"
    
    echo "$timestamp: Starting network risk monitoring" >> "$network_log"
    
    # Check network connections
    local established_connections=$(ss -tun | grep ESTAB | wc -l)
    local listening_ports=$(ss -tuln | grep LISTEN | wc -l)
    
    # Check for suspicious network activity (common attack ports)
    local suspicious_connections=$(ss -tun | grep -E ":1433|:3389|:5432|:23|:21" | wc -l)
    
    # Check network interfaces
    local network_interfaces=$(ip link show | grep -E "^[0-9]" | wc -l)
    
    # Create network risk data
    cat > "$network_data" << EOJSON
{
    "timestamp": "$timestamp",
    "established_connections": $established_connections,
    "listening_ports": $listening_ports,
    "suspicious_connections": $suspicious_connections,
    "network_interfaces": $network_interfaces,
    "system": "$(hostname)"
}
EOJSON

    # Calculate network risk score
    local network_risk_score=$((suspicious_connections * 5 + established_connections / 10 + listening_ports / 2))
    
    # Log network assessment
    echo "$timestamp|NETWORK_ASSESSMENT|Score:$network_risk_score|Established:$established_connections|Listening:$listening_ports|Suspicious:$suspicious_connections" >> "$network_log"
    
    # Generate alert if high risk
    if [ "$network_risk_score" -gt 10 ]; then
        generate_risk_alert "NETWORK" "HIGH" "Network risk score elevated: $network_risk_score" "$network_data"
    fi
    
    echo "Network monitoring completed. Risk score: $network_risk_score"
}

# Function to monitor asset risks
monitor_asset_risks() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local asset_log="$LOG_DIR/asset_monitoring.log"
    local asset_data="$DATA_DIR/current_asset_status.json"
    
    echo "$timestamp: Starting asset risk monitoring" >> "$asset_log"
    
    # Check system resources
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d'.' -f1)
    local memory_usage=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
    
    # Check system load
    local load_average=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    
    # Check running processes
    local process_count=$(ps aux | wc -l)
    
    # Create asset risk data
    cat > "$asset_data" << EOJSON
{
    "timestamp": "$timestamp",
    "cpu_usage": ${cpu_usage:-0},
    "memory_usage": $memory_usage,
    "disk_usage": $disk_usage,
    "load_average": "$load_average",
    "process_count": $process_count,
    "system": "$(hostname)"
}
EOJSON

    # Calculate asset risk score based on resource utilization
    local asset_risk_score=$(echo "${cpu_usage:-0} + $memory_usage + $disk_usage" | bc 2>/dev/null || echo "0")
    
    # Log asset assessment
    echo "$timestamp|ASSET_ASSESSMENT|Score:$asset_risk_score|CPU:${cpu_usage:-0}%|Memory:$memory_usage%|Disk:$disk_usage%|Load:$load_average" >> "$asset_log"
    
    # Generate alert if high risk
    if [ "${asset_risk_score%.*}" -gt 150 ]; then
        generate_risk_alert "ASSET" "HIGH" "Asset utilization risk elevated: $asset_risk_score" "$asset_data"
    fi
    
    echo "Asset monitoring completed. Risk score: $asset_risk_score"
}

# Function to generate risk alerts
generate_risk_alert() {
    local alert_type=$1
    local severity=$2
    local message=$3
    local data_file=$4
    
    local alert_id="ALERT_$(date +%Y%m%d_%H%M%S)_$$"
    local alert_file="$ALERTS_DIR/alert_$alert_id.json"
    
    cat > "$alert_file" << EOJSON
{
    "alert_id": "$alert_id",
    "alert_type": "$alert_type",
    "severity": "$severity",
    "message": "$message",
    "timestamp": "$(date '+%Y-%m-%d %H:%M:%S')",
    "system": "$(hostname)",
    "data_source": "$data_file",
    "status": "ACTIVE"
}
EOJSON

    echo "Risk alert generated: $alert_id ($severity $alert_type)"
    
    # Log alert generation
    echo "$(date '+%Y-%m-%d %H:%M:%S')|ALERT_GENERATED|$alert_id|$alert_type|$severity|$message" >> "$LOG_DIR/alerts.log"
    
    # Send notification to system log
    echo "RISK ALERT: $alert_type - $severity - $message" | logger -t RISK_MONITORING
}

# Function to run continuous monitoring
run_continuous_monitoring() {
    echo "Starting continuous risk monitoring..."
    echo "Press Ctrl+C to stop"
    
    local cycle_count=0
    
    while true; do
        cycle_count=$((cycle_count + 1))
        echo "=== Monitoring Cycle $cycle_count - $(date) ==="
        
        # Run all monitoring functions
        monitor_system_vulnerabilities
        monitor_network_risks
        monitor_asset_risks
        
        echo "Monitoring cycle $cycle_count completed"
        echo "Next cycle in 30 seconds..."
        sleep 30
    done
}

# Main script logic
case "$1" in
    "vulnerability")
        monitor_system_vulnerabilities
        ;;
    "network")
        monitor_network_risks
        ;;
    "asset")
        monitor_asset_risks
        ;;
    "continuous")
        run_continuous_monitoring
        ;;
    "all")
        monitor_system_vulnerabilities
        monitor_network_risks
        monitor_asset_risks
        ;;
    *)
        echo "Usage: $0 {vulnerability|network|asset|continuous|all}"
        echo "  vulnerability: Monitor system vulnerabilities"
        echo "  network: Monitor network risks"
        echo "  asset: Monitor asset risks"
        echo "  continuous: Run continuous monitoring (Ctrl+C to stop)"
        echo "  all: Run all monitoring checks once"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x /opt/risk_management/scripts/continuous_monitoring.sh
```

### Step 2: Test the Monitoring System

```bash
# Navigate to the scripts directory
cd /opt/risk_management/scripts

# Test individual monitoring functions
echo "Testing vulnerability monitoring..."
./continuous_monitoring.sh vulnerability

echo "Testing network monitoring..."
./continuous_monitoring.sh network

echo "Testing asset monitoring..."
./continuous_monitoring.sh asset

# Run all monitoring checks once
echo "Running comprehensive monitoring check..."
./continuous_monitoring.sh all
```

### Step 3: View Monitoring Results

```bash
# Check the monitoring logs
echo "=== VULNERABILITY MONITORING LOG ==="
tail -10 /opt/risk_management/monitoring/logs/vulnerability_monitoring.log

echo "=== NETWORK MONITORING LOG ==="
tail -10 /opt/risk_management/monitoring/logs/network_monitoring.log

echo "=== ASSET MONITORING LOG ==="
tail -10 /opt/risk_management/monitoring/logs/asset_monitoring.log

# Check for any alerts generated
echo "=== GENERATED ALERTS ==="
if [ -d "/opt/risk_management/monitoring/alerts" ]; then
    ls -la /opt/risk_management/monitoring/alerts/
    
    # Display the latest alert if any
    latest_alert=$(ls -t /opt/risk_management/monitoring/alerts/alert_*.json 2>/dev/null | head -1)
    if [ -n "$latest_alert" ]; then
        echo "Latest Alert:"
        cat "$latest_alert"
    fi
fi

# View current monitoring data
echo "=== CURRENT VULNERABILITY DATA ==="
if [ -f "/opt/risk_management/monitoring/data/current_vulnerabilities.json" ]; then
    cat /opt/risk_management/monitoring/data/current_vulnerabilities.json
fi
```

### Step 4: Run Continuous Monitoring (Optional)

**Note**: This will run continuously until you stop it with Ctrl+C. Only run this if you have time and want to see real-time monitoring.

```bash
# Start continuous monitoring (run in background or separate terminal)
# ./continuous_monitoring.sh continuous

# Instead, let's simulate a few monitoring cycles
echo "Simulating monitoring cycles..."
for i in {1..3}; do
    echo "=== Monitoring Cycle $i ==="
    ./continuous_monitoring.sh all
    echo "Waiting 10 seconds before next cycle..."
    sleep 10
done
```

### Questions for Exercise 2:

1. **Monitoring Frequency**: How often should you run continuous monitoring in a production environment?

2. **Alert Thresholds**: How would you determine appropriate thresholds for generating alerts?

3. **Data Storage**: What are the considerations for storing large amounts of monitoring data?

4. **Integration**: How could you integrate this monitoring system with existing security tools?

---

## Exercise 3: Risk Quantification and Modeling

### Objective
Implement advanced risk quantification using the FAIR (Factor Analysis of Information Risk) methodology and Monte Carlo simulations to provide financial impact analysis of risks.

### Background
Quantitative risk analysis provides financial context to risk management decisions. In this exercise, you'll implement:
- FAIR methodology for risk quantification
- Monte Carlo simulations for uncertainty modeling
- Statistical analysis of risk scenarios
- Financial impact calculations and reporting

### Step 1: Install Required Python Libraries

```bash
# Install additional Python libraries for statistical analysis
pip3 install matplotlib seaborn plotly scipy

# Verify installation
python3 -c "import numpy, matplotlib, pandas, scipy; print('All libraries installed successfully')"
```

### Step 2: Create the FAIR Analysis Script

```bash
# Create the FAIR analysis Python script
cat > /opt/risk_management/scripts/fair_analysis.py << 'EOF'
#!/usr/bin/env python3
"""
FAIR (Factor Analysis of Information Risk) Implementation
Quantitative risk analysis using FAIR methodology
"""

import json
import sqlite3
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from datetime import datetime
import os
import sys

class FAIRAnalysis:
    def __init__(self, db_path):
        self.db_path = db_path
        self.results_dir = "/opt/risk_management/quantification/fair_results"
        os.makedirs(self.results_dir, exist_ok=True)
    
    def calculate_threat_event_frequency(self, threat_capability, control_strength):
        """Calculate Threat Event Frequency (TEF)"""
        if control_strength == 0:
            return 10  # Maximum frequency if no controls
        
        tef = min(threat_capability / control_strength * 2, 10)
        return round(tef, 2)
    
    def calculate_vulnerability(self, control_strength, threat_capability):
        """Calculate Vulnerability"""
        if threat_capability == 0:
            return 0
        
        vulnerability = max(1 - (control_strength / threat_capability), 0)
        return round(vulnerability, 2)
    
    def calculate_loss_event_frequency(self, tef, vulnerability):
        """Calculate Loss Event Frequency (LEF)"""
        lef = tef * vulnerability
        return round(lef, 2)
    
    def calculate_primary_loss(self, asset_value, impact_percentage):
        """Calculate Primary Loss"""
        primary_loss = asset_value * (impact_percentage / 100)
        return round(primary_loss, 2)
    
    def calculate_secondary_loss(self, primary_loss, secondary_factors):
        """Calculate Secondary Loss"""
        secondary_loss = primary_loss * secondary_factors
        return round(secondary_loss, 2)
    
    def monte_carlo_simulation(self, lef_range, loss_range, iterations=10000):
        """Perform Monte Carlo simulation for risk quantification"""
        results = []
        
        for _ in range(iterations):
            # Sample from distributions
            lef = np.random.uniform(lef_range[0], lef_range[1])
            loss = np.random.uniform(loss_range[0], loss_range[1])
            
            # Calculate annual loss expectancy
            ale = lef * loss
            results.append(ale)
        
        return np.array(results)
    
    def perform_fair_analysis(self, asset_id, threat_id, scenario_params):
        """Perform complete FAIR analysis for a risk scenario"""
        analysis_id = f"FAIR_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
        # Extract parameters
        threat_capability = scenario_params.get('threat_capability', 5)
        control_strength = scenario_params.get('control_strength', 5)
        asset_value = scenario_params.get('asset_value', 100000)
        impact_percentage = scenario_params.get('impact_percentage', 20)
        secondary_factors = scenario_params.get('secondary_factors', 1.5)
        
        # Calculate FAIR components
        tef = self.calculate_threat_event_frequency(threat_capability, control_strength)
        vulnerability = self.calculate_vulnerability(control_strength, threat_capability)
        lef = self.calculate_loss_event_frequency(tef, vulnerability)
        
        primary_loss = self.calculate_primary_loss(asset_value, impact_percentage)
        secondary_loss = self.calculate_secondary_loss(primary_loss, secondary_factors)
        total_loss = primary_loss + secondary_loss
        
        # Calculate Annual Loss Expectancy (ALE)
        ale = lef * total_loss
        
        # Perform Monte Carlo simulation
        lef_range = (lef * 0.5, lef * 1.5)
        loss_range = (total_loss * 0.7, total_loss * 1.3)
        simulation_results = self.monte_carlo_simulation(lef_range, loss_range)
        
        # Calculate statistics
        ale_mean = np.mean(simulation_results)
        ale_median = np.median(simulation_results)
        ale_95th = np.percentile(simulation_results, 95)
        ale_std = np.std(simulation_results)
        
        # Create analysis results
        analysis_results = {
            'analysis_id': analysis_id,
            'asset_id': asset_id,
            'threat_id': threat_id,
            'timestamp': datetime.now().isoformat(),
            'fair_components': {
                'threat_event_frequency': tef,
                'vulnerability': vulnerability,
                'loss_event_frequency': lef,
                'primary_loss': primary_loss,
                'secondary_loss': secondary_loss,
                'total_loss': total_loss,
                'annual_loss_expectancy': ale
            },
            'monte_carlo_results': {
                'iterations': len(simulation_results),
                'ale_mean': ale_mean,
                'ale_median': ale_median,
                'ale_95th_percentile': ale_95th,
                'ale_standard_deviation': ale_std,
                'ale_minimum': np.min(simulation_results),
                'ale_maximum': np.max(simulation_results)
            },
            'scenario_parameters': scenario_params
        }
        
        # Save results
        results_file = f"{self.results_dir}/fair_analysis_{analysis_id}.json"
        with open(results_file, 'w') as f:
            json.dump(analysis_results, f, indent=2)
        
        # Generate visualization
        self.create_visualization(analysis_results, simulation_results)
        
        return analysis_results
    
    def create_visualization(self, analysis_results, simulation_results):
        """Create visualization of FAIR analysis results"""
        analysis_id = analysis_results['analysis_id']
        
        # Create figure with subplots
        fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(15, 10))
        fig.suptitle(f'FAIR Risk Analysis - {analysis_id}', fontsize=16)
        
        # 1. FAIR Components Bar Chart
        components = analysis_results['fair_components']
        comp_names = ['TEF', 'Vulnerability', 'LEF']
        comp_values = [
            components['threat_event_frequency'],
            components['vulnerability'],
            components['loss_event_frequency']
        ]
        
        ax1.bar(comp_names, comp_values)
        ax1.set_title('FAIR Risk Components')
        ax1.set_ylabel('Value')
        
        # 2. Monte Carlo Distribution
        ax2.hist(simulation_results / 1000, bins=50, alpha=0.7, edgecolor='black')
        ax2.axvline(np.mean(simulation_results) / 1000, color='red', linestyle='--', label='Mean')
        ax2.axvline(np.percentile(simulation_results, 95) / 1000, color='orange', linestyle='--', label='95th Percentile')
        ax2.set_title('Annual Loss Expectancy Distribution')
        ax2.set_xlabel('ALE ($K)')
        ax2.set_ylabel('Frequency')
        ax2.legend()
        
        # 3. Loss Components
        loss_components = ['Primary Loss', 'Secondary Loss']
        loss_values = [components['primary_loss'], components['secondary_loss']]
        
        ax3.pie(loss_values, labels=loss_components, autopct='%1.1f%%')
        ax3.set_title('Loss Components')
        
        # 4. Risk Level Assessment
        ale_mean = np.mean(simulation_results)
        if ale_mean < 10000:
            risk_level = "LOW"
            color = 'green'
        elif ale_mean < 50000:
            risk_level = "MEDIUM"
            color = 'yellow'
        elif ale_mean < 200000:
            risk_level = "HIGH"
            color = 'orange'
        else:
            risk_level = "CRITICAL"
            color = 'red'
        
        ax4.bar(['Risk Level'], [ale_mean], color=color)
        ax4.set_title(f'Risk Level: {risk_level}')
        ax4.set_ylabel('Annual Loss Expectancy ($)')
        
        plt.tight_layout()
        
        # Save visualization
        viz_file = f"{self.results_dir}/fair_visualization_{analysis_id}.png"
        plt.savefig(viz_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"Visualization saved: {viz_file}")
    
    def generate_fair_report(self, analysis_results):
        """Generate comprehensive FAIR analysis report"""
        analysis_id = analysis_results['analysis_id']
        report_file = f"{self.results_dir}/fair_report_{analysis_id}.txt"
        
        with open(report_file, 'w') as f:
            f.write("=" * 60 + "\n")
            f.write("FAIR RISK QUANTIFICATION REPORT\n")
            f.write("=" * 60 + "\n\n")
            
            f.write(f"Analysis ID: {analysis_id}\n")
            f.write(f"Asset ID: {analysis_results['asset_id']}\n")
            f.write(f"Threat ID: {analysis_results['threat_id']}\n")
            f.write(f"Analysis Date: {analysis_results['timestamp']}\n\n")
            
            f.write("FAIR COMPONENTS:\n")
            f.write("-" * 20 + "\n")
            components = analysis_results['fair_components']
            f.write(f"Threat Event Frequency (TEF): {components['threat_event_frequency']}\n")
            f.write(f"Vulnerability: {components['vulnerability']}\n")
            f.write(f"Loss Event Frequency (LEF): {components['loss_event_frequency']}\n")
            f.write(f"Primary Loss: ${components['primary_loss']:,.2f}\n")
            f.write(f"Secondary Loss: ${components['secondary_loss']:,.2f}\n")
            f.write(f"Total Loss: ${components['total_loss']:,.2f}\n")
            f.write(f"Annual Loss Expectancy (ALE): ${components['annual_loss_expectancy']:,.2f}\n\n")
            
            f.write("MONTE CARLO SIMULATION RESULTS:\n")
            f.write("-" * 35 + "\n")
            mc_results = analysis_results['monte_carlo_results']
            f.write(f"Iterations: {mc_results['iterations']:,}\n")
            f.write(f"Mean ALE: ${mc_results['ale_mean']:,.2f}\n")
            f.write(f"Median ALE: ${mc_results['ale_median']:,.2f}\n")
            f.write(f"95th Percentile ALE: ${mc_results['ale_95th_percentile']:,.2f}\n")
            f.write(f"Standard Deviation: ${mc_results['ale_standard_deviation']:,.2f}\n")
            f.write(f"Minimum ALE: ${mc_results['ale_minimum']:,.2f}\n")
            f.write(f"Maximum ALE: ${mc_results['ale_maximum']:,.2f}\n\n")
            
            f.write("RISK INTERPRETATION:\n")
            f.write("-" * 20 + "\n")
            ale_mean = mc_results['ale_mean']
            if ale_mean < 10000:
                risk_level = "LOW"
                recommendation = "Monitor and maintain current controls"
            elif ale_mean < 50000:
                risk_level = "MEDIUM"
                recommendation = "Consider additional controls and monitoring"
            elif ale_mean < 200000:
                risk_level = "HIGH"
                recommendation = "Implement additional controls immediately"
            else:
                risk_level = "CRITICAL"
                recommendation = "Urgent action required - consider risk transfer or avoidance"
            
            f.write(f"Risk Level: {risk_level}\n")
            f.write(f"Recommendation: {recommendation}\n\n")
            
            f.write("SCENARIO PARAMETERS:\n")
            f.write("-" * 20 + "\n")
            params = analysis_results['scenario_parameters']
            for key, value in params.items():
                f.write(f"{key.replace('_', ' ').title()}: {value}\n")
        
        print(f"FAIR report generated: {report_file}")
        return report_file

def main():
    if len(sys.argv) < 4:
        print("Usage: python3 fair_analysis.py <asset_id> <threat_id> <scenario_json>")
        print("Example: python3 fair_analysis.py AST_001 THR_001 '{\"threat_capability\": 7, \"control_strength\": 4, \"asset_value\": 500000, \"impact_percentage\": 25, \"secondary_factors\": 1.8}'")
        sys.exit(1)
    
    asset_id = sys.argv[1]
    threat_id = sys.argv[2]
    scenario_json = sys.argv[3]
    
    try:
        scenario_params = json.loads(scenario_json)
    except json.JSONDecodeError:
        print("Error: Invalid JSON in scenario parameters")
        sys.exit(1)
    
    # Initialize FAIR analysis
    db_path = "/opt/risk_management/data/database/risk_management.db"
    fair = FAIRAnalysis(db_path)
    
    # Perform analysis
    print(f"Performing FAIR analysis for Asset: {asset_id}, Threat: {threat_id}")
    results = fair.perform_fair_analysis(asset_id, threat_id, scenario_params)
    
    # Generate report
    report_file = fair.generate_fair_report(results)
    
    print(f"\nFAIR Analysis completed successfully!")
    print(f"Analysis ID: {results['analysis_id']}")
    print(f"Annual Loss Expectancy: ${results['monte_carlo_results']['ale_mean']:,.2f}")
    print(f"95th Percentile ALE: ${results['monte_carlo_results']['ale_95th_percentile']:,.2f}")

if __name__ == "__main__":
    main()
EOF

# Make the Python script executable
chmod +x /opt/risk_management/scripts/fair_analysis.py
```

### Step 3: Perform FAIR Analysis

```bash
# Navigate to the scripts directory
cd /opt/risk_management/scripts

# Create the quantification results directory
mkdir -p /opt/risk_management/quantification/fair_results

# Perform FAIR analysis for different scenarios

echo "Performing FAIR analysis for high-value database server..."
python3 fair_analysis.py AST_002 THR_004 '{"threat_capability": 8, "control_strength": 4, "asset_value": 1000000, "impact_percentage": 30, "secondary_factors": 2.0}'

echo "Performing FAIR analysis for web server..."
python3 fair_analysis.py AST_001 THR_001 '{"threat_capability": 6, "control_strength": 6, "asset_value": 500000, "impact_percentage": 20, "secondary_factors": 1.5}'

echo "Performing FAIR analysis for workstation..."
python3 fair_analysis.py AST_003 THR_002 '{"threat_capability": 4, "control_strength": 7, "asset_value": 50000, "impact_percentage": 15, "secondary_factors": 1.2}'
```

### Step 4: Review FAIR Analysis Results

```bash
# List all FAIR analysis results
echo "=== FAIR ANALYSIS RESULTS ==="
ls -la /opt/risk_management/quantification/fair_results/

# Display the latest FAIR report
latest_report=$(ls -t /opt/risk_management/quantification/fair_results/fair_report_*.txt | head -1)
if [ -n "$latest_report" ]; then
    echo "=== LATEST FAIR REPORT ==="
    cat "$latest_report"
fi

# Display the latest FAIR analysis JSON
latest_json=$(ls -t /opt/risk_management/quantification/fair_results/fair_analysis_*.json | head -1)
if [ -n "$latest_json" ]; then
    echo "=== LATEST FAIR ANALYSIS DATA ==="
    cat "$latest_json" | python3 -m json.tool
fi
```

### Step 5: Create Risk Summary Dashboard

```bash
# Create a simple risk summary script
cat > /opt/risk_management/scripts/risk_summary.sh << 'EOF'
#!/bin/bash
# Risk Management Summary Dashboard

RISK_BASE="/opt/risk_management"
DB_FILE="$RISK_BASE/data/database/risk_management.db"

echo "=========================================="
echo "RISK MANAGEMENT SUMMARY DASHBOARD"
echo "=========================================="
echo "Generated: $(date)"
echo ""

# Risk Assessment Summary
echo "RISK ASSESSMENT SUMMARY:"
echo "------------------------"
sqlite3 "$DB_FILE" << EOSQL
SELECT 
    'Total Assessments: ' || COUNT(*) as summary
FROM risk_assessments 
WHERE status = 'ACTIVE';

SELECT 
    'Critical Risks: ' || COUNT(*) as summary
FROM risk_assessments 
WHERE status = 'ACTIVE' AND risk_level = 'CRITICAL';

SELECT 
    'High Risks: ' || COUNT(*) as summary
FROM risk_assessments 
WHERE status = 'ACTIVE' AND risk_level = 'HIGH';

SELECT 
    'Medium Risks: ' || COUNT(*) as summary
FROM risk_assessments 
WHERE status = 'ACTIVE' AND risk_level = 'MEDIUM';

SELECT 
    'Low Risks: ' || COUNT(*) as summary
FROM risk_assessments 
WHERE status = 'ACTIVE' AND risk_level = 'LOW';

SELECT 
    'Average Risk Score: ' || ROUND(AVG(risk_score), 2) as summary
FROM risk_assessments 
WHERE status = 'ACTIVE';
EOSQL

echo ""

# Top Risks
echo "TOP 5 RISKS:"
echo "------------"
sqlite3 "$DB_FILE" << EOSQL
.mode column
.headers on
SELECT 
    a.asset_name as Asset,
    t.threat_name as Threat,
    ra.risk_score as Score,
    ra.risk_level as Level
FROM risk_assessments ra
JOIN assets a ON ra.asset_id = a.asset_id
JOIN threats t ON ra.threat_id = t.threat_id
WHERE ra.status = 'ACTIVE'
ORDER BY ra.risk_score DESC
LIMIT 5;
EOSQL

echo ""

# FAIR Analysis Summary (if available)
if [ -d "/opt/risk_management/quantification/fair_results" ]; then
    fair_count=$(ls /opt/risk_management/quantification/fair_results/fair_analysis_*.json 2>/dev/null | wc -l)
    if [ "$fair_count" -gt 0 ]; then
        echo "FAIR ANALYSIS SUMMARY:"
        echo "----------------------"
        echo "Total FAIR Analyses: $fair_count"
        
        # Calculate total ALE from all FAIR analyses
        total_ale=0
        for fair_file in /opt/risk_management/quantification/fair_results/fair_analysis_*.json; do
            if [ -f "$fair_file" ]; then
                ale=$(python3 -c "import json; data=json.load(open('$fair_file')); print(data['monte_carlo_results']['ale_mean'])" 2>/dev/null || echo "0")
                total_ale=$(echo "$total_ale + $ale" | bc 2>/dev/null || echo "$total_ale")
            fi
        done
        
        echo "Total Annual Loss Expectancy: \$$(printf '%.2f' $total_ale)"
    fi
fi

echo ""

# Recent Monitoring Alerts
if [ -d "/opt/risk_management/monitoring/alerts" ]; then
    alert_count=$(ls /opt/risk_management/monitoring/alerts/alert_*.json 2>/dev/null | wc -l)
    if [ "$alert_count" -gt 0 ]; then
        echo "RECENT MONITORING ALERTS:"
        echo "-------------------------"
        echo "Total Alerts: $alert_count"
        
        # Show latest 3 alerts
        ls -t /opt/risk_management/monitoring/alerts/alert_*.json 2>/dev/null | head -3 | while read alert_file; do
            if [ -f "$alert_file" ]; then
                echo "Alert: $(basename "$alert_file")"
                python3 -c "import json; data=json.load(open('$alert_file')); print(f'  Type: {data[\"alert_type\"]} | Severity: {data[\"severity\"]} | Time: {data[\"timestamp\"]}')" 2>/dev/null
            fi
        done
    fi
fi

echo ""
echo "=========================================="
EOF

# Make the summary script executable
chmod +x /opt/risk_management/scripts/risk_summary.sh

# Run the risk summary
./risk_summary.sh
```

### Questions for Exercise 3:

1. **FAIR Methodology**: How does FAIR help in making risk-based business decisions?

2. **Monte Carlo Simulation**: Why is Monte Carlo simulation useful for risk analysis?

3. **Financial Impact**: How would you present quantitative risk results to executive management?

4. **Uncertainty**: How does the FAIR model handle uncertainty in risk calculations?

---

## Lab Completion and Assessment

### Lab Deliverables

Please complete the following deliverables and submit them for assessment:

1. **Risk Assessment Database**: Export your risk assessment database
```bash
# Export the database
sqlite3 /opt/risk_management/data/database/risk_management.db .dump > risk_database_export.sql
```

2. **Risk Register**: Generate and save your final risk register
```bash
cd /opt/risk_management/scripts
./risk_assessment_engine.sh register
```

3. **Monitoring Logs**: Collect your monitoring logs
```bash
# Create a monitoring summary
tar -czf monitoring_logs.tar.gz /opt/risk_management/monitoring/logs/
```

4. **FAIR Analysis Results**: Package your FAIR analysis results
```bash
# Package FAIR results
tar -czf fair_analysis_results.tar.gz /opt/risk_management/quantification/fair_results/
```

5. **Final Risk Summary**: Generate your final risk summary
```bash
cd /opt/risk_management/scripts
./risk_summary.sh > final_risk_summary.txt
```

### Self-Assessment Questions

1. **Risk Assessment Framework**:
   - How effective is your risk scoring methodology?
   - What improvements would you make to the risk assessment process?

2. **Continuous Monitoring**:
   - How would you optimize the monitoring frequency and thresholds?
   - What additional monitoring capabilities would enhance the system?

3. **Risk Quantification**:
   - How confident are you in your FAIR analysis results?
   - What factors could improve the accuracy of your quantitative analysis?

4. **Integration and Automation**:
   - How well do the different components work together?
   - What automation improvements would you implement?

### Reflection Questions

1. **Practical Application**: How would you implement these risk management techniques in a real organization?

2. **Tool Selection**: What are the advantages and disadvantages of using Linux-based tools for risk management?

3. **Scalability**: How would you scale these solutions for a large enterprise environment?

4. **Integration**: How would these tools integrate with existing enterprise risk management platforms?

### Next Steps

After completing this lab, consider exploring:

1. **Advanced Risk Modeling**: Machine learning approaches to risk prediction
2. **Enterprise Integration**: Connecting with SIEM and GRC platforms
3. **Regulatory Compliance**: Mapping risk assessments to compliance requirements
4. **Risk Visualization**: Advanced dashboard and reporting techniques

---

## Troubleshooting Guide

### Common Issues and Solutions

1. **Database Connection Issues**:
   - Verify SQLite installation: `sqlite3 --version`
   - Check file permissions: `ls -la /opt/risk_management/data/database/`
   - Recreate database if corrupted

2. **Python Script Errors**:
   - Verify Python libraries: `pip3 list | grep -E "(numpy|matplotlib|pandas)"`
   - Check Python version: `python3 --version`
   - Install missing dependencies

3. **Monitoring Script Issues**:
   - Check system permissions for log access
   - Verify network tools installation: `which ss netstat`
   - Review log files for error messages

4. **FAIR Analysis Problems**:
   - Validate JSON input format
   - Check mathematical calculations
   - Verify output directory permissions

### Getting Help

If you encounter issues during the lab:

1. Review the error messages carefully
2. Check the troubleshooting guide above
3. Verify all prerequisites are installed
4. Ask your instructor for assistance
5. Collaborate with classmates (where appropriate)

---

**Congratulations on completing the Risk Management Fundamentals lab! You have gained hands-on experience with modern risk management techniques using Linux tools and methodologies.**

