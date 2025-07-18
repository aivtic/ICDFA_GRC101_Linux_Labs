# Week 3 Linux Lab: Risk Management Fundamentals
## Instructor Guide

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
**Course: GRC101 - Introduction to Governance, Risk, and Compliance**  
**Lab Duration: 3 hours**  
**Difficulty Level: Intermediate to Advanced**

---

## Lab Overview

This comprehensive lab focuses on implementing enterprise risk management using Linux tools and methodologies. Students will learn to create automated risk assessment systems, implement continuous risk monitoring, develop risk quantification models, and build comprehensive risk reporting dashboards. The lab emphasizes practical implementation of modern risk management frameworks including NIST RMF, ISO 31000, and FAIR (Factor Analysis of Information Risk).

### Learning Objectives

By the end of this lab, students will be able to:
1. Implement automated risk assessment and identification systems
2. Create continuous risk monitoring using Linux tools
3. Develop risk quantification models and calculations
4. Build risk dashboards and reporting mechanisms
5. Implement threat intelligence integration for risk assessment
6. Understand how Linux supports enterprise risk management
7. Create risk response and mitigation tracking systems

### Prerequisites

- Completion of Week 1 and Week 2 Linux Labs
- Understanding of risk management frameworks
- Advanced Linux command-line skills
- Basic knowledge of statistics and probability
- Familiarity with network security and system monitoring

---

## Lab Environment Setup

### Required Software and Tools
- Linux OS (Ubuntu 22.04 LTS recommended)
- Python 3.x with data analysis libraries (pandas, numpy, matplotlib)
- Database systems (SQLite, MySQL/PostgreSQL)
- Network monitoring tools (nmap, netstat, ss)
- System monitoring tools (htop, iotop, vmstat)
- Log analysis tools (awk, sed, grep, jq)
- Statistical analysis tools (R or Python scipy)
- Visualization tools (gnuplot, matplotlib)

### Pre-Lab Preparation
1. Install risk assessment and monitoring tools
2. Set up sample network and system environments
3. Create test datasets for risk analysis
4. Prepare risk assessment templates and frameworks
5. Configure monitoring infrastructure for risk data collection

### Installation Commands
```bash
# Update system and install base tools
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

# Install additional utilities
sudo apt install -y jq xmlstarlet csvkit curl wget
```

---

## Exercise 1: Risk Assessment Framework Implementation (75 minutes)

### Instructor Notes
This exercise teaches students to implement a comprehensive risk assessment framework using Linux tools. Focus on automated risk identification, qualitative and quantitative risk analysis, and risk prioritization. Emphasize the integration of multiple data sources for comprehensive risk assessment.

### Learning Outcomes
- Implement automated risk identification systems
- Create qualitative and quantitative risk assessment models
- Develop risk scoring and prioritization mechanisms
- Build risk assessment databases and tracking systems
- Generate comprehensive risk assessment reports

### Setup Instructions
1. Create risk assessment database schemas
2. Set up automated data collection systems
3. Implement risk scoring algorithms
4. Configure risk assessment workflows
5. Prepare sample risk scenarios for testing

### Step-by-Step Walkthrough

#### Part A: Risk Assessment Infrastructure Setup
```bash
# Create comprehensive risk management directory structure
sudo mkdir -p /opt/risk_management/{assessment,monitoring,quantification,reporting,intelligence}
sudo mkdir -p /opt/risk_management/assessment/{identification,analysis,evaluation,treatment}
sudo mkdir -p /opt/risk_management/monitoring/{continuous,periodic,event_driven}
sudo mkdir -p /opt/risk_management/data/{assets,threats,vulnerabilities,controls}

# Set up proper permissions
sudo chown -R root:risk-admin /opt/risk_management
sudo chmod -R 750 /opt/risk_management

# Create risk management groups
sudo groupadd risk-admin
sudo groupadd risk-analyst
sudo groupadd risk-manager
sudo groupadd asset-owner
```

#### Part B: Risk Database Implementation
Students will create a comprehensive risk database to store and manage risk information.

```bash
#!/bin/bash
# Risk Assessment Database Setup Script
# File: /opt/risk_management/scripts/setup_risk_database.sh

RISK_BASE="/opt/risk_management"
DB_DIR="$RISK_BASE/data/database"
SCRIPTS_DIR="$RISK_BASE/scripts"

mkdir -p "$DB_DIR"
mkdir -p "$SCRIPTS_DIR"

# Create SQLite database for risk management
sqlite3 "$DB_DIR/risk_management.db" << 'EOF'
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

-- Create Controls table
CREATE TABLE IF NOT EXISTS controls (
    control_id TEXT PRIMARY KEY,
    control_name TEXT NOT NULL,
    control_type TEXT NOT NULL,
    control_family TEXT,
    implementation_status TEXT NOT NULL,
    effectiveness INTEGER,
    cost REAL,
    responsible_party TEXT,
    description TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO assets VALUES 
('AST_001', 'Web Server', 'Server', 8, 'HIGH', 'IT Team', 'Data Center', 'Primary web application server', datetime('now'), datetime('now')),
('AST_002', 'Database Server', 'Database', 9, 'CRITICAL', 'DBA Team', 'Data Center', 'Customer database server', datetime('now'), datetime('now')),
('AST_003', 'Workstation', 'Endpoint', 5, 'MEDIUM', 'User', 'Office', 'Employee workstation', datetime('now'), datetime('now'));

INSERT INTO threats VALUES 
('THR_001', 'Malware Attack', 'Cyber', 'External', 7, 'Malicious software targeting systems', datetime('now'), datetime('now')),
('THR_002', 'Insider Threat', 'Human', 'Internal', 4, 'Malicious or negligent insider actions', datetime('now'), datetime('now')),
('THR_003', 'DDoS Attack', 'Cyber', 'External', 6, 'Distributed denial of service attack', datetime('now'), datetime('now'));

INSERT INTO vulnerabilities VALUES 
('VUL_001', 'Unpatched Software', 'Technical', 8, 7.5, 'AST_001,AST_003', 'Missing security patches', 'Apply security updates', datetime('now'), datetime('now')),
('VUL_002', 'Weak Passwords', 'Human', 6, 5.0, 'AST_001,AST_002,AST_003', 'Inadequate password policies', 'Implement strong password policy', datetime('now'), datetime('now')),
('VUL_003', 'Network Exposure', 'Technical', 7, 6.8, 'AST_001,AST_002', 'Unnecessary network services', 'Implement network segmentation', datetime('now'), datetime('now'));

EOF

echo "Risk management database created successfully"
```

#### Part C: Automated Risk Assessment Engine
```bash
#!/bin/bash
# Automated Risk Assessment Engine
# File: /opt/risk_management/scripts/risk_assessment_engine.sh

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

# Function to perform automated risk assessment
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
    sqlite3 "$DB_FILE" << EOF
INSERT INTO risk_assessments (
    assessment_id, asset_id, threat_id, vuln_id, 
    likelihood, impact, risk_score, risk_level, assessor
) VALUES (
    '$assessment_id', '$asset_id', '$threat_id', '$vuln_id',
    $likelihood, $impact, $risk_score, '$risk_level', '$assessor'
);
EOF

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
    
    # Query assessment details
    sqlite3 "$DB_FILE" << EOF > "$report_file"
.mode column
.headers on
.output '$report_file'

SELECT 
    'RISK ASSESSMENT REPORT' as title;
    
SELECT 
    'Assessment ID: ' || ra.assessment_id as assessment_info,
    'Date: ' || ra.assessment_date as date_info,
    'Assessor: ' || ra.assessor as assessor_info;

SELECT 
    'ASSET INFORMATION' as section;
    
SELECT 
    'Asset ID: ' || a.asset_id as asset_id,
    'Asset Name: ' || a.asset_name as asset_name,
    'Asset Type: ' || a.asset_type as asset_type,
    'Business Value: ' || a.business_value as business_value,
    'Criticality: ' || a.criticality as criticality
FROM risk_assessments ra
JOIN assets a ON ra.asset_id = a.asset_id
WHERE ra.assessment_id = '$assessment_id';

SELECT 
    'THREAT INFORMATION' as section;
    
SELECT 
    'Threat ID: ' || t.threat_id as threat_id,
    'Threat Name: ' || t.threat_name as threat_name,
    'Threat Type: ' || t.threat_type as threat_type,
    'Threat Source: ' || t.threat_source as threat_source
FROM risk_assessments ra
JOIN threats t ON ra.threat_id = t.threat_id
WHERE ra.assessment_id = '$assessment_id';

SELECT 
    'RISK ANALYSIS' as section;
    
SELECT 
    'Likelihood: ' || ra.likelihood as likelihood,
    'Impact: ' || ra.impact as impact,
    'Risk Score: ' || ra.risk_score as risk_score,
    'Risk Level: ' || ra.risk_level as risk_level
FROM risk_assessments ra
WHERE ra.assessment_id = '$assessment_id';

EOF

    echo "Assessment report generated: $report_file"
}

# Function to perform bulk risk assessment
perform_bulk_assessment() {
    echo "Performing bulk risk assessment for all asset-threat combinations..."
    
    # Get all assets and threats for comprehensive assessment
    sqlite3 "$DB_FILE" "SELECT asset_id FROM assets;" | while read asset_id; do
        sqlite3 "$DB_FILE" "SELECT threat_id FROM threats;" | while read threat_id; do
            # Calculate likelihood and impact based on asset criticality and threat likelihood
            local asset_criticality=$(sqlite3 "$DB_FILE" "SELECT business_value FROM assets WHERE asset_id='$asset_id';")
            local threat_likelihood=$(sqlite3 "$DB_FILE" "SELECT likelihood FROM threats WHERE threat_id='$threat_id';")
            
            # Simple calculation for demonstration (in real implementation, this would be more sophisticated)
            local likelihood=$threat_likelihood
            local impact=$asset_criticality
            
            # Find relevant vulnerability
            local vuln_id=$(sqlite3 "$DB_FILE" "SELECT vuln_id FROM vulnerabilities WHERE affected_assets LIKE '%$asset_id%' LIMIT 1;")
            
            if [ -n "$vuln_id" ]; then
                perform_risk_assessment "$asset_id" "$threat_id" "$vuln_id" "$likelihood" "$impact" "Automated_Assessment"
            else
                perform_risk_assessment "$asset_id" "$threat_id" "NULL" "$likelihood" "$impact" "Automated_Assessment"
            fi
        done
    done
    
    echo "Bulk risk assessment completed"
}

# Function to generate risk register
generate_risk_register() {
    local register_file="$REPORTS_DIR/risk_register_$(date +%Y%m%d_%H%M%S).csv"
    
    sqlite3 "$DB_FILE" << EOF
.mode csv
.headers on
.output '$register_file'

SELECT 
    ra.assessment_id,
    a.asset_name,
    t.threat_name,
    v.vuln_name,
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

EOF

    echo "Risk register generated: $register_file"
}

# Main script logic
case "$1" in
    "assess")
        if [ $# -ne 7 ]; then
            echo "Usage: $0 assess <asset_id> <threat_id> <vuln_id> <likelihood> <impact> <assessor>"
            exit 1
        fi
        perform_risk_assessment "$2" "$3" "$4" "$5" "$6" "$7"
        ;;
    "bulk")
        perform_bulk_assessment
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
        echo "Usage: $0 {assess|bulk|register|report} [arguments]"
        echo "  assess: Perform individual risk assessment"
        echo "  bulk: Perform bulk assessment for all assets and threats"
        echo "  register: Generate comprehensive risk register"
        echo "  report: Generate individual assessment report"
        exit 1
        ;;
esac
```

### Assessment Criteria
- Proper risk database design and implementation
- Effective risk scoring and prioritization algorithms
- Quality of automated assessment processes
- Comprehensive risk reporting capabilities
- Understanding of risk assessment methodologies

### Common Issues and Solutions
1. **Database Connection Issues**: Verify SQLite installation and file permissions
2. **Risk Scoring Logic**: Ensure proper mathematical calculations and validations
3. **Data Quality**: Implement input validation and data consistency checks
4. **Performance Issues**: Optimize database queries and bulk operations

---

## Exercise 2: Continuous Risk Monitoring Implementation (90 minutes)

### Instructor Notes
This exercise focuses on implementing continuous risk monitoring systems using Linux tools. Students will learn to create real-time risk monitoring, automated threat detection, and dynamic risk assessment updates. Emphasize the importance of continuous monitoring in modern risk management.

### Learning Outcomes
- Implement real-time risk monitoring systems
- Create automated threat and vulnerability detection
- Develop dynamic risk assessment updates
- Build risk alerting and notification systems
- Integrate multiple data sources for comprehensive monitoring

### Setup Instructions
1. Configure system and network monitoring tools
2. Set up automated vulnerability scanning
3. Implement threat intelligence feeds
4. Create risk monitoring dashboards
5. Configure alerting and notification systems

### Step-by-Step Walkthrough

#### Part A: System Risk Monitoring Setup
```bash
#!/bin/bash
# Continuous Risk Monitoring System
# File: /opt/risk_management/scripts/continuous_monitoring.sh

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
    
    # Check for running services with known vulnerabilities
    local running_services=$(systemctl list-units --type=service --state=running | grep -E "(apache|nginx|mysql|ssh)" | wc -l)
    
    # Check for open ports
    local open_ports=$(netstat -tuln | grep LISTEN | wc -l)
    
    # Check for failed login attempts
    local failed_logins=$(grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date +%b\ %d)" | wc -l)
    
    # Create vulnerability data in JSON format
    cat > "$vuln_data" << EOF
{
    "timestamp": "$timestamp",
    "security_updates": $security_updates,
    "running_services": $running_services,
    "open_ports": $open_ports,
    "failed_logins": $failed_logins,
    "system": "$(hostname)",
    "monitoring_status": "active"
}
EOF

    # Calculate vulnerability risk score
    local vuln_risk_score=$((security_updates * 2 + failed_logins + open_ports))
    
    # Log vulnerability assessment
    echo "$timestamp|VULN_ASSESSMENT|Score:$vuln_risk_score|Updates:$security_updates|Services:$running_services|Ports:$open_ports|FailedLogins:$failed_logins" >> "$vuln_log"
    
    # Generate alert if high risk
    if [ "$vuln_risk_score" -gt 20 ]; then
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
    local established_connections=$(netstat -tun | grep ESTABLISHED | wc -l)
    local listening_ports=$(netstat -tuln | grep LISTEN | wc -l)
    
    # Check for suspicious network activity
    local suspicious_connections=$(netstat -tun | grep -E ":1433|:3389|:5432|:23|:21" | wc -l)
    
    # Check bandwidth usage (simplified)
    local network_interfaces=$(ip link show | grep -E "^[0-9]" | wc -l)
    
    # Create network risk data
    cat > "$network_data" << EOF
{
    "timestamp": "$timestamp",
    "established_connections": $established_connections,
    "listening_ports": $listening_ports,
    "suspicious_connections": $suspicious_connections,
    "network_interfaces": $network_interfaces,
    "system": "$(hostname)"
}
EOF

    # Calculate network risk score
    local network_risk_score=$((suspicious_connections * 5 + established_connections / 10 + listening_ports))
    
    # Log network assessment
    echo "$timestamp|NETWORK_ASSESSMENT|Score:$network_risk_score|Established:$established_connections|Listening:$listening_ports|Suspicious:$suspicious_connections" >> "$network_log"
    
    # Generate alert if high risk
    if [ "$network_risk_score" -gt 15 ]; then
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
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local memory_usage=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
    
    # Check system load
    local load_average=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    
    # Check running processes
    local process_count=$(ps aux | wc -l)
    
    # Create asset risk data
    cat > "$asset_data" << EOF
{
    "timestamp": "$timestamp",
    "cpu_usage": ${cpu_usage%.*},
    "memory_usage": $memory_usage,
    "disk_usage": $disk_usage,
    "load_average": "$load_average",
    "process_count": $process_count,
    "system": "$(hostname)"
}
EOF

    # Calculate asset risk score based on resource utilization
    local asset_risk_score=$(echo "${cpu_usage%.*} + $memory_usage + $disk_usage" | bc)
    
    # Log asset assessment
    echo "$timestamp|ASSET_ASSESSMENT|Score:$asset_risk_score|CPU:${cpu_usage%.*}%|Memory:$memory_usage%|Disk:$disk_usage%|Load:$load_average" >> "$asset_log"
    
    # Generate alert if high risk
    if [ "${asset_risk_score%.*}" -gt 200 ]; then
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
    
    cat > "$alert_file" << EOF
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
EOF

    echo "Risk alert generated: $alert_id ($severity $alert_type)"
    
    # Log alert generation
    echo "$(date '+%Y-%m-%d %H:%M:%S')|ALERT_GENERATED|$alert_id|$alert_type|$severity|$message" >> "$LOG_DIR/alerts.log"
    
    # Send notification (simplified - in real implementation, this would integrate with notification systems)
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
        
        # Update risk assessments based on monitoring data
        update_dynamic_risk_assessments
        
        echo "Monitoring cycle $cycle_count completed"
        echo "Next cycle in 60 seconds..."
        sleep 60
    done
}

# Function to update dynamic risk assessments
update_dynamic_risk_assessments() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local update_log="$LOG_DIR/dynamic_updates.log"
    
    echo "$timestamp: Updating dynamic risk assessments" >> "$update_log"
    
    # Read current monitoring data
    if [ -f "$DATA_DIR/current_vulnerabilities.json" ]; then
        local vuln_score=$(jq -r '.security_updates' "$DATA_DIR/current_vulnerabilities.json" 2>/dev/null || echo "0")
        
        # Update vulnerability-related risk assessments in database
        sqlite3 "$RISK_BASE/data/database/risk_management.db" << EOF
UPDATE risk_assessments 
SET likelihood = CASE 
    WHEN $vuln_score > 10 THEN LEAST(likelihood + 2, 10)
    WHEN $vuln_score > 5 THEN LEAST(likelihood + 1, 10)
    ELSE likelihood
END,
updated_date = datetime('now')
WHERE vuln_id IS NOT NULL;
EOF
    fi
    
    echo "$timestamp: Dynamic risk assessment updates completed" >> "$update_log"
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
    "update")
        update_dynamic_risk_assessments
        ;;
    "all")
        monitor_system_vulnerabilities
        monitor_network_risks
        monitor_asset_risks
        update_dynamic_risk_assessments
        ;;
    *)
        echo "Usage: $0 {vulnerability|network|asset|continuous|update|all}"
        echo "  vulnerability: Monitor system vulnerabilities"
        echo "  network: Monitor network risks"
        echo "  asset: Monitor asset risks"
        echo "  continuous: Run continuous monitoring (Ctrl+C to stop)"
        echo "  update: Update dynamic risk assessments"
        echo "  all: Run all monitoring checks once"
        exit 1
        ;;
esac
```

#### Part B: Threat Intelligence Integration
```bash
#!/bin/bash
# Threat Intelligence Integration Script
# File: /opt/risk_management/scripts/threat_intelligence.sh

RISK_BASE="/opt/risk_management"
INTEL_DIR="$RISK_BASE/intelligence"
FEEDS_DIR="$INTEL_DIR/feeds"
ANALYSIS_DIR="$INTEL_DIR/analysis"
LOG_DIR="$INTEL_DIR/logs"

mkdir -p "$FEEDS_DIR" "$ANALYSIS_DIR" "$LOG_DIR"

# Function to collect threat intelligence feeds
collect_threat_feeds() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local feed_log="$LOG_DIR/threat_feeds.log"
    
    echo "$timestamp: Starting threat intelligence collection" >> "$feed_log"
    
    # Simulate threat intelligence feed collection (in real implementation, this would connect to actual feeds)
    # For demonstration, we'll create sample threat data
    
    # CVE Feed Simulation
    cat > "$FEEDS_DIR/cve_feed_$(date +%Y%m%d).json" << 'EOF'
{
    "feed_type": "CVE",
    "timestamp": "2024-01-15T10:00:00Z",
    "threats": [
        {
            "cve_id": "CVE-2024-0001",
            "severity": "HIGH",
            "cvss_score": 8.5,
            "description": "Remote code execution vulnerability in web server",
            "affected_products": ["Apache", "Nginx"],
            "published_date": "2024-01-15"
        },
        {
            "cve_id": "CVE-2024-0002",
            "severity": "MEDIUM",
            "cvss_score": 6.2,
            "description": "SQL injection vulnerability in database interface",
            "affected_products": ["MySQL", "PostgreSQL"],
            "published_date": "2024-01-15"
        }
    ]
}
EOF

    # Malware Feed Simulation
    cat > "$FEEDS_DIR/malware_feed_$(date +%Y%m%d).json" << 'EOF'
{
    "feed_type": "MALWARE",
    "timestamp": "2024-01-15T10:00:00Z",
    "indicators": [
        {
            "hash": "a1b2c3d4e5f6789012345678901234567890abcd",
            "type": "SHA256",
            "malware_family": "TrojanX",
            "threat_level": "HIGH",
            "first_seen": "2024-01-14",
            "description": "Banking trojan targeting financial institutions"
        },
        {
            "ip": "192.168.100.50",
            "type": "IP",
            "threat_type": "C2_SERVER",
            "threat_level": "MEDIUM",
            "first_seen": "2024-01-13",
            "description": "Command and control server"
        }
    ]
}
EOF

    echo "$timestamp: Threat intelligence feeds collected" >> "$feed_log"
    echo "Threat intelligence feeds updated"
}

# Function to analyze threat intelligence
analyze_threat_intelligence() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local analysis_log="$LOG_DIR/threat_analysis.log"
    local analysis_report="$ANALYSIS_DIR/threat_analysis_$(date +%Y%m%d_%H%M%S).txt"
    
    echo "$timestamp: Starting threat intelligence analysis" >> "$analysis_log"
    
    echo "=== THREAT INTELLIGENCE ANALYSIS REPORT ===" > "$analysis_report"
    echo "Generated: $(date)" >> "$analysis_report"
    echo "" >> "$analysis_report"
    
    # Analyze CVE feeds
    echo "=== CVE THREAT ANALYSIS ===" >> "$analysis_report"
    local cve_files=$(find "$FEEDS_DIR" -name "cve_feed_*.json" -mtime -1)
    
    if [ -n "$cve_files" ]; then
        for cve_file in $cve_files; do
            echo "Processing CVE feed: $(basename "$cve_file")" >> "$analysis_report"
            
            # Extract high severity CVEs
            local high_severity_count=$(jq '[.threats[] | select(.severity == "HIGH")] | length' "$cve_file" 2>/dev/null || echo "0")
            local medium_severity_count=$(jq '[.threats[] | select(.severity == "MEDIUM")] | length' "$cve_file" 2>/dev/null || echo "0")
            
            echo "High severity CVEs: $high_severity_count" >> "$analysis_report"
            echo "Medium severity CVEs: $medium_severity_count" >> "$analysis_report"
            
            # List high severity CVEs
            if [ "$high_severity_count" -gt 0 ]; then
                echo "High severity CVE details:" >> "$analysis_report"
                jq -r '.threats[] | select(.severity == "HIGH") | "- \(.cve_id): \(.description) (CVSS: \(.cvss_score))"' "$cve_file" 2>/dev/null >> "$analysis_report"
            fi
        done
    else
        echo "No recent CVE feeds found" >> "$analysis_report"
    fi
    
    echo "" >> "$analysis_report"
    
    # Analyze malware feeds
    echo "=== MALWARE THREAT ANALYSIS ===" >> "$analysis_report"
    local malware_files=$(find "$FEEDS_DIR" -name "malware_feed_*.json" -mtime -1)
    
    if [ -n "$malware_files" ]; then
        for malware_file in $malware_files; do
            echo "Processing malware feed: $(basename "$malware_file")" >> "$analysis_report"
            
            local high_threat_count=$(jq '[.indicators[] | select(.threat_level == "HIGH")] | length' "$malware_file" 2>/dev/null || echo "0")
            local medium_threat_count=$(jq '[.indicators[] | select(.threat_level == "MEDIUM")] | length' "$malware_file" 2>/dev/null || echo "0")
            
            echo "High threat indicators: $high_threat_count" >> "$analysis_report"
            echo "Medium threat indicators: $medium_threat_count" >> "$analysis_report"
        done
    else
        echo "No recent malware feeds found" >> "$analysis_report"
    fi
    
    echo "" >> "$analysis_report"
    
    # Generate threat recommendations
    echo "=== THREAT MITIGATION RECOMMENDATIONS ===" >> "$analysis_report"
    echo "1. Apply security patches for high severity CVEs immediately" >> "$analysis_report"
    echo "2. Update threat detection signatures with new malware indicators" >> "$analysis_report"
    echo "3. Review and update security controls based on emerging threats" >> "$analysis_report"
    echo "4. Conduct targeted risk assessments for affected assets" >> "$analysis_report"
    
    echo "$timestamp: Threat intelligence analysis completed: $analysis_report" >> "$analysis_log"
    echo "Threat intelligence analysis completed: $analysis_report"
}

# Function to update risk assessments based on threat intelligence
update_risk_from_intelligence() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local update_log="$LOG_DIR/intelligence_updates.log"
    
    echo "$timestamp: Updating risk assessments from threat intelligence" >> "$update_log"
    
    # Check for high severity threats affecting our assets
    local cve_files=$(find "$FEEDS_DIR" -name "cve_feed_*.json" -mtime -1)
    
    for cve_file in $cve_files; do
        # Extract high severity CVEs
        local high_severity_cves=$(jq -r '.threats[] | select(.severity == "HIGH") | .cve_id' "$cve_file" 2>/dev/null)
        
        for cve in $high_severity_cves; do
            # Update likelihood for related vulnerabilities
            sqlite3 "$RISK_BASE/data/database/risk_management.db" << EOF
UPDATE risk_assessments 
SET likelihood = LEAST(likelihood + 2, 10),
    updated_date = datetime('now')
WHERE vuln_id IN (
    SELECT vuln_id FROM vulnerabilities 
    WHERE vuln_name LIKE '%patch%' OR vuln_name LIKE '%software%'
);
EOF
            
            echo "$timestamp: Updated risk assessments for CVE: $cve" >> "$update_log"
        done
    done
    
    echo "$timestamp: Risk assessment updates from threat intelligence completed" >> "$update_log"
    echo "Risk assessments updated based on threat intelligence"
}

# Main script logic
case "$1" in
    "collect")
        collect_threat_feeds
        ;;
    "analyze")
        analyze_threat_intelligence
        ;;
    "update")
        update_risk_from_intelligence
        ;;
    "all")
        collect_threat_feeds
        analyze_threat_intelligence
        update_risk_from_intelligence
        ;;
    *)
        echo "Usage: $0 {collect|analyze|update|all}"
        echo "  collect: Collect threat intelligence feeds"
        echo "  analyze: Analyze collected threat intelligence"
        echo "  update: Update risk assessments based on intelligence"
        echo "  all: Run complete threat intelligence workflow"
        exit 1
        ;;
esac
```

### Assessment Criteria
- Effective continuous monitoring implementation
- Quality of threat intelligence integration
- Proper dynamic risk assessment updates
- Comprehensive alerting and notification systems
- Understanding of real-time risk management concepts

### Troubleshooting Guide
1. **Monitoring Performance**: Optimize monitoring intervals and resource usage
2. **Data Integration**: Ensure proper JSON parsing and data validation
3. **Alert Fatigue**: Implement proper alert thresholds and filtering
4. **Database Updates**: Verify database connectivity and transaction handling

---

## Exercise 3: Risk Quantification and Modeling (105 minutes)

### Instructor Notes
This advanced exercise teaches students to implement quantitative risk analysis using statistical methods and financial modeling. Students will learn FAIR methodology, Monte Carlo simulations, and advanced risk calculations. This exercise requires strong mathematical understanding and programming skills.

### Learning Outcomes
- Implement FAIR (Factor Analysis of Information Risk) methodology
- Create Monte Carlo simulations for risk analysis
- Develop financial impact modeling
- Build statistical risk analysis tools
- Generate quantitative risk reports and visualizations

### Setup Instructions
1. Install statistical analysis tools (Python scipy, R)
2. Set up data visualization libraries
3. Create financial impact calculation models
4. Implement Monte Carlo simulation frameworks
5. Prepare quantitative analysis templates

### Step-by-Step Walkthrough

#### Part A: FAIR Methodology Implementation
```bash
#!/bin/bash
# FAIR Risk Quantification Implementation
# File: /opt/risk_management/scripts/fair_analysis.py

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
        """
        Calculate Threat Event Frequency (TEF)
        TEF = Threat Capability / Control Strength
        """
        if control_strength == 0:
            return 10  # Maximum frequency if no controls
        
        tef = min(threat_capability / control_strength * 2, 10)
        return round(tef, 2)
    
    def calculate_vulnerability(self, control_strength, threat_capability):
        """
        Calculate Vulnerability
        Vulnerability = 1 - (Control Strength / Threat Capability)
        """
        if threat_capability == 0:
            return 0
        
        vulnerability = max(1 - (control_strength / threat_capability), 0)
        return round(vulnerability, 2)
    
    def calculate_loss_event_frequency(self, tef, vulnerability):
        """
        Calculate Loss Event Frequency (LEF)
        LEF = TEF × Vulnerability
        """
        lef = tef * vulnerability
        return round(lef, 2)
    
    def calculate_primary_loss(self, asset_value, impact_percentage):
        """
        Calculate Primary Loss
        Primary Loss = Asset Value × Impact Percentage
        """
        primary_loss = asset_value * (impact_percentage / 100)
        return round(primary_loss, 2)
    
    def calculate_secondary_loss(self, primary_loss, secondary_factors):
        """
        Calculate Secondary Loss
        Secondary Loss = Primary Loss × Secondary Factors
        """
        secondary_loss = primary_loss * secondary_factors
        return round(secondary_loss, 2)
    
    def monte_carlo_simulation(self, lef_range, loss_range, iterations=10000):
        """
        Perform Monte Carlo simulation for risk quantification
        """
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
        """
        Perform complete FAIR analysis for a risk scenario
        """
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
        """
        Create visualization of FAIR analysis results
        """
        analysis_id = analysis_results['analysis_id']
        
        # Create figure with subplots
        fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(15, 10))
        fig.suptitle(f'FAIR Risk Analysis - {analysis_id}', fontsize=16)
        
        # 1. FAIR Components Bar Chart
        components = analysis_results['fair_components']
        comp_names = ['TEF', 'Vulnerability', 'LEF', 'Primary Loss', 'Secondary Loss', 'ALE']
        comp_values = [
            components['threat_event_frequency'],
            components['vulnerability'],
            components['loss_event_frequency'],
            components['primary_loss'] / 1000,  # Scale for visualization
            components['secondary_loss'] / 1000,
            components['annual_loss_expectancy'] / 1000
        ]
        
        ax1.bar(comp_names, comp_values)
        ax1.set_title('FAIR Components')
        ax1.set_ylabel('Value (Loss in $K)')
        ax1.tick_params(axis='x', rotation=45)
        
        # 2. Monte Carlo Distribution
        ax2.hist(simulation_results / 1000, bins=50, alpha=0.7, edgecolor='black')
        ax2.axvline(np.mean(simulation_results) / 1000, color='red', linestyle='--', label='Mean')
        ax2.axvline(np.percentile(simulation_results, 95) / 1000, color='orange', linestyle='--', label='95th Percentile')
        ax2.set_title('Annual Loss Expectancy Distribution')
        ax2.set_xlabel('ALE ($K)')
        ax2.set_ylabel('Frequency')
        ax2.legend()
        
        # 3. Risk Level Gauge
        ale_mean = np.mean(simulation_results)
        risk_levels = ['Low', 'Medium', 'High', 'Critical']
        risk_thresholds = [10000, 50000, 200000, float('inf')]
        
        for i, threshold in enumerate(risk_thresholds):
            if ale_mean <= threshold:
                risk_level = risk_levels[i]
                break
        
        ax3.pie([1], labels=[f'Risk Level: {risk_level}'], autopct=f'ALE: ${ale_mean:,.0f}')
        ax3.set_title('Risk Level Assessment')
        
        # 4. Sensitivity Analysis
        sensitivity_data = []
        for factor in np.arange(0.5, 2.1, 0.1):
            modified_results = simulation_results * factor
            sensitivity_data.append(np.mean(modified_results))
        
        ax4.plot(np.arange(0.5, 2.1, 0.1), np.array(sensitivity_data) / 1000)
        ax4.set_title('Sensitivity Analysis')
        ax4.set_xlabel('Factor Multiplier')
        ax4.set_ylabel('ALE ($K)')
        ax4.grid(True)
        
        plt.tight_layout()
        
        # Save visualization
        viz_file = f"{self.results_dir}/fair_visualization_{analysis_id}.png"
        plt.savefig(viz_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"Visualization saved: {viz_file}")
    
    def generate_fair_report(self, analysis_results):
        """
        Generate comprehensive FAIR analysis report
        """
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
        print("Example: python3 fair_analysis.py AST_001 THR_001 '{\"threat_capability\": 7, \"control_strength\": 4, \"asset_value\": 500000}'")
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

#### Part B: Risk Quantification Dashboard
```bash
#!/bin/bash
# Risk Quantification Dashboard Script
# File: /opt/risk_management/scripts/risk_quantification_dashboard.py

cat > /opt/risk_management/scripts/risk_quantification_dashboard.py << 'EOF'
#!/usr/bin/env python3
"""
Risk Quantification Dashboard
Comprehensive risk metrics and visualization dashboard
"""

import json
import sqlite3
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from datetime import datetime, timedelta
import os
import glob

class RiskQuantificationDashboard:
    def __init__(self):
        self.risk_base = "/opt/risk_management"
        self.db_path = f"{self.risk_base}/data/database/risk_management.db"
        self.dashboard_dir = f"{self.risk_base}/reporting/dashboard"
        os.makedirs(self.dashboard_dir, exist_ok=True)
    
    def load_risk_data(self):
        """Load risk assessment data from database"""
        conn = sqlite3.connect(self.db_path)
        
        # Load risk assessments with asset and threat details
        query = """
        SELECT 
            ra.assessment_id,
            ra.asset_id,
            a.asset_name,
            a.business_value,
            ra.threat_id,
            t.threat_name,
            ra.likelihood,
            ra.impact,
            ra.risk_score,
            ra.risk_level,
            ra.assessment_date
        FROM risk_assessments ra
        JOIN assets a ON ra.asset_id = a.asset_id
        JOIN threats t ON ra.threat_id = t.threat_id
        WHERE ra.status = 'ACTIVE'
        ORDER BY ra.risk_score DESC
        """
        
        df = pd.read_sql_query(query, conn)
        conn.close()
        
        return df
    
    def load_fair_results(self):
        """Load FAIR analysis results"""
        fair_results = []
        fair_files = glob.glob(f"{self.risk_base}/quantification/fair_results/fair_analysis_*.json")
        
        for file_path in fair_files:
            try:
                with open(file_path, 'r') as f:
                    data = json.load(f)
                    fair_results.append(data)
            except Exception as e:
                print(f"Error loading FAIR file {file_path}: {e}")
        
        return fair_results
    
    def calculate_portfolio_metrics(self, risk_df, fair_results):
        """Calculate portfolio-level risk metrics"""
        metrics = {}
        
        # Basic risk metrics
        metrics['total_risks'] = len(risk_df)
        metrics['critical_risks'] = len(risk_df[risk_df['risk_level'] == 'CRITICAL'])
        metrics['high_risks'] = len(risk_df[risk_df['risk_level'] == 'HIGH'])
        metrics['medium_risks'] = len(risk_df[risk_df['risk_level'] == 'MEDIUM'])
        metrics['low_risks'] = len(risk_df[risk_df['risk_level'] == 'LOW'])
        
        # Average risk score
        metrics['avg_risk_score'] = risk_df['risk_score'].mean()
        metrics['max_risk_score'] = risk_df['risk_score'].max()
        
        # FAIR metrics
        if fair_results:
            ales = [result['monte_carlo_results']['ale_mean'] for result in fair_results]
            metrics['total_ale'] = sum(ales)
            metrics['avg_ale'] = np.mean(ales)
            metrics['max_ale'] = max(ales)
            metrics['ale_95th'] = np.percentile(ales, 95)
        else:
            metrics['total_ale'] = 0
            metrics['avg_ale'] = 0
            metrics['max_ale'] = 0
            metrics['ale_95th'] = 0
        
        return metrics
    
    def create_risk_dashboard(self):
        """Create comprehensive risk dashboard"""
        # Load data
        risk_df = self.load_risk_data()
        fair_results = self.load_fair_results()
        metrics = self.calculate_portfolio_metrics(risk_df, fair_results)
        
        # Create dashboard figure
        fig = plt.figure(figsize=(20, 12))
        fig.suptitle('Risk Management Dashboard', fontsize=20, fontweight='bold')
        
        # 1. Risk Level Distribution (Pie Chart)
        ax1 = plt.subplot(2, 4, 1)
        risk_counts = [metrics['critical_risks'], metrics['high_risks'], 
                      metrics['medium_risks'], metrics['low_risks']]
        risk_labels = ['Critical', 'High', 'Medium', 'Low']
        colors = ['red', 'orange', 'yellow', 'green']
        
        ax1.pie(risk_counts, labels=risk_labels, colors=colors, autopct='%1.1f%%')
        ax1.set_title('Risk Level Distribution')
        
        # 2. Top 10 Risks by Score (Bar Chart)
        ax2 = plt.subplot(2, 4, 2)
        top_risks = risk_df.head(10)
        ax2.barh(range(len(top_risks)), top_risks['risk_score'])
        ax2.set_yticks(range(len(top_risks)))
        ax2.set_yticklabels([f"{row['asset_name'][:15]}..." for _, row in top_risks.iterrows()])
        ax2.set_xlabel('Risk Score')
        ax2.set_title('Top 10 Risks by Score')
        
        # 3. Risk Score Distribution (Histogram)
        ax3 = plt.subplot(2, 4, 3)
        ax3.hist(risk_df['risk_score'], bins=20, alpha=0.7, edgecolor='black')
        ax3.axvline(metrics['avg_risk_score'], color='red', linestyle='--', label='Average')
        ax3.set_xlabel('Risk Score')
        ax3.set_ylabel('Frequency')
        ax3.set_title('Risk Score Distribution')
        ax3.legend()
        
        # 4. Asset Risk Profile (Scatter Plot)
        ax4 = plt.subplot(2, 4, 4)
        scatter = ax4.scatter(risk_df['likelihood'], risk_df['impact'], 
                             c=risk_df['business_value'], s=risk_df['risk_score']*2, 
                             alpha=0.6, cmap='viridis')
        ax4.set_xlabel('Likelihood')
        ax4.set_ylabel('Impact')
        ax4.set_title('Risk Profile (size=risk score, color=business value)')
        plt.colorbar(scatter, ax=ax4)
        
        # 5. FAIR Analysis Results (if available)
        if fair_results:
            ax5 = plt.subplot(2, 4, 5)
            ales = [result['monte_carlo_results']['ale_mean'] for result in fair_results]
            asset_ids = [result['asset_id'] for result in fair_results]
            
            ax5.bar(range(len(ales)), ales)
            ax5.set_xticks(range(len(ales)))
            ax5.set_xticklabels(asset_ids, rotation=45)
            ax5.set_ylabel('Annual Loss Expectancy ($)')
            ax5.set_title('FAIR Analysis - ALE by Asset')
        
        # 6. Risk Trend (Time Series) - Simulated
        ax6 = plt.subplot(2, 4, 6)
        dates = pd.date_range(start='2024-01-01', periods=30, freq='D')
        risk_trend = np.random.normal(metrics['avg_risk_score'], 5, 30)
        ax6.plot(dates, risk_trend)
        ax6.set_xlabel('Date')
        ax6.set_ylabel('Average Risk Score')
        ax6.set_title('Risk Trend (30 days)')
        ax6.tick_params(axis='x', rotation=45)
        
        # 7. Risk Heat Map
        ax7 = plt.subplot(2, 4, 7)
        likelihood_bins = np.arange(1, 11)
        impact_bins = np.arange(1, 11)
        
        # Create heat map data
        heat_data = np.zeros((10, 10))
        for _, row in risk_df.iterrows():
            l_idx = min(int(row['likelihood']) - 1, 9)
            i_idx = min(int(row['impact']) - 1, 9)
            heat_data[i_idx, l_idx] += 1
        
        im = ax7.imshow(heat_data, cmap='Reds', aspect='auto')
        ax7.set_xlabel('Likelihood')
        ax7.set_ylabel('Impact')
        ax7.set_title('Risk Heat Map')
        ax7.set_xticks(range(10))
        ax7.set_xticklabels(range(1, 11))
        ax7.set_yticks(range(10))
        ax7.set_yticklabels(range(1, 11))
        plt.colorbar(im, ax=ax7)
        
        # 8. Key Metrics Summary
        ax8 = plt.subplot(2, 4, 8)
        ax8.axis('off')
        
        metrics_text = f"""
        KEY RISK METRICS
        ================
        
        Total Risks: {metrics['total_risks']}
        Critical: {metrics['critical_risks']}
        High: {metrics['high_risks']}
        Medium: {metrics['medium_risks']}
        Low: {metrics['low_risks']}
        
        Avg Risk Score: {metrics['avg_risk_score']:.1f}
        Max Risk Score: {metrics['max_risk_score']}
        
        Total ALE: ${metrics['total_ale']:,.0f}
        Avg ALE: ${metrics['avg_ale']:,.0f}
        Max ALE: ${metrics['max_ale']:,.0f}
        """
        
        ax8.text(0.1, 0.9, metrics_text, transform=ax8.transAxes, 
                fontsize=10, verticalalignment='top', fontfamily='monospace')
        
        plt.tight_layout()
        
        # Save dashboard
        dashboard_file = f"{self.dashboard_dir}/risk_dashboard_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        plt.savefig(dashboard_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"Risk dashboard saved: {dashboard_file}")
        return dashboard_file, metrics
    
    def generate_executive_summary(self, metrics):
        """Generate executive summary report"""
        summary_file = f"{self.dashboard_dir}/executive_summary_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
        
        with open(summary_file, 'w') as f:
            f.write("=" * 60 + "\n")
            f.write("EXECUTIVE RISK SUMMARY\n")
            f.write("=" * 60 + "\n\n")
            
            f.write(f"Report Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            f.write("RISK PORTFOLIO OVERVIEW:\n")
            f.write("-" * 25 + "\n")
            f.write(f"Total Risk Assessments: {metrics['total_risks']}\n")
            f.write(f"Critical Risks: {metrics['critical_risks']} ({metrics['critical_risks']/metrics['total_risks']*100:.1f}%)\n")
            f.write(f"High Risks: {metrics['high_risks']} ({metrics['high_risks']/metrics['total_risks']*100:.1f}%)\n")
            f.write(f"Medium Risks: {metrics['medium_risks']} ({metrics['medium_risks']/metrics['total_risks']*100:.1f}%)\n")
            f.write(f"Low Risks: {metrics['low_risks']} ({metrics['low_risks']/metrics['total_risks']*100:.1f}%)\n\n")
            
            f.write("QUANTITATIVE RISK ANALYSIS:\n")
            f.write("-" * 28 + "\n")
            f.write(f"Total Annual Loss Expectancy: ${metrics['total_ale']:,.2f}\n")
            f.write(f"Average ALE per Risk: ${metrics['avg_ale']:,.2f}\n")
            f.write(f"Maximum Single Risk ALE: ${metrics['max_ale']:,.2f}\n")
            f.write(f"95th Percentile ALE: ${metrics['ale_95th']:,.2f}\n\n")
            
            f.write("KEY FINDINGS:\n")
            f.write("-" * 13 + "\n")
            
            # Generate findings based on metrics
            if metrics['critical_risks'] > 0:
                f.write(f"• {metrics['critical_risks']} critical risks require immediate attention\n")
            
            if metrics['total_ale'] > 1000000:
                f.write(f"• High financial exposure: Total ALE exceeds $1M\n")
            
            if metrics['critical_risks'] + metrics['high_risks'] > metrics['total_risks'] * 0.3:
                f.write(f"• Risk concentration: {(metrics['critical_risks'] + metrics['high_risks'])/metrics['total_risks']*100:.1f}% of risks are high/critical\n")
            
            f.write("\nRECOMMENDations:\n")
            f.write("-" * 16 + "\n")
            f.write("• Prioritize mitigation of critical and high-risk items\n")
            f.write("• Implement continuous monitoring for top risk scenarios\n")
            f.write("• Consider risk transfer options for high ALE scenarios\n")
            f.write("• Review and update risk assessments quarterly\n")
            f.write("• Enhance controls for assets with highest business value\n")
        
        print(f"Executive summary generated: {summary_file}")
        return summary_file

def main():
    dashboard = RiskQuantificationDashboard()
    
    print("Generating risk quantification dashboard...")
    dashboard_file, metrics = dashboard.create_risk_dashboard()
    
    print("Generating executive summary...")
    summary_file = dashboard.generate_executive_summary(metrics)
    
    print(f"\nDashboard generation completed!")
    print(f"Dashboard: {dashboard_file}")
    print(f"Executive Summary: {summary_file}")
    
    # Print key metrics to console
    print(f"\nKey Metrics:")
    print(f"Total Risks: {metrics['total_risks']}")
    print(f"Critical/High Risks: {metrics['critical_risks'] + metrics['high_risks']}")
    print(f"Total ALE: ${metrics['total_ale']:,.2f}")

if __name__ == "__main__":
    main()
EOF

# Make the dashboard script executable
chmod +x /opt/risk_management/scripts/risk_quantification_dashboard.py
```

### Assessment Criteria
- Proper implementation of FAIR methodology
- Effective Monte Carlo simulation techniques
- Quality of quantitative risk calculations
- Comprehensive visualization and reporting
- Understanding of advanced risk quantification concepts

### Advanced Extensions
1. Integration with real-time data feeds
2. Machine learning for risk prediction
3. Advanced statistical modeling techniques
4. Integration with enterprise risk management platforms

---

## Assessment and Grading

### Comprehensive Assessment Rubric (100 points total)

#### Exercise 1: Risk Assessment Framework (25 points)
- Database design and implementation (8 points)
- Risk scoring algorithms (6 points)
- Automated assessment processes (6 points)
- Reporting capabilities (5 points)

#### Exercise 2: Continuous Risk Monitoring (30 points)
- Real-time monitoring implementation (10 points)
- Threat intelligence integration (8 points)
- Dynamic risk updates (7 points)
- Alerting and notification systems (5 points)

#### Exercise 3: Risk Quantification and Modeling (35 points)
- FAIR methodology implementation (12 points)
- Monte Carlo simulation accuracy (10 points)
- Statistical analysis quality (8 points)
- Visualization and dashboard creation (5 points)

#### Integration and Understanding (10 points)
- System integration effectiveness (5 points)
- Demonstration of risk management concepts (5 points)

### Post-Lab Activities

#### Reflection Questions
1. How does quantitative risk analysis improve decision-making compared to qualitative methods?
2. What are the challenges of implementing continuous risk monitoring in enterprise environments?
3. How can automation enhance the effectiveness of risk management programs?
4. What role does threat intelligence play in modern risk assessment?

#### Follow-Up Assignments
1. Research emerging risk quantification methodologies
2. Compare Linux-based risk tools with commercial solutions
3. Design a risk management automation strategy
4. Analyze real-world risk management case studies

---

*This instructor guide provides comprehensive support for delivering advanced risk management education using Linux platforms. The exercises demonstrate practical implementation of modern risk management frameworks through hands-on technical implementation and quantitative analysis.*

