# ICDFA GRC101 Sample Data Package

## Overview

This package contains comprehensive sample data files for the International Cybersecurity and Digital Forensics Academy (ICDFA) GRC101 course: "Introduction to Governance, Risk, and Compliance." The sample data is designed to support hands-on Linux laboratory exercises across all four weeks of the course.

## Package Contents

### Week 1: GRC Frameworks and Principles
**Directory:** `Week1/`

- **databases/grc_frameworks.sql** - Sample GRC frameworks database with organizational structures, policies, and governance data
- **policies/information_security_policy.md** - Comprehensive information security policy template
- **configs/grc_system_config.yaml** - GRC system configuration file with framework settings

**Learning Objectives:**
- Understanding GRC framework implementation
- Policy development and management
- Organizational governance structures
- GRC system configuration and setup

### Week 2: Regulatory Environment and Standards
**Directory:** `Week2/`

- **databases/regulatory_compliance.sql** - Comprehensive regulatory compliance database with GDPR, HIPAA, PCI DSS, and SOX data
- **configs/gdpr_compliance_config.json** - Detailed GDPR compliance configuration with data processing activities
- **logs/compliance_audit.log** - Sample compliance monitoring and audit log files

**Learning Objectives:**
- Regulatory framework analysis
- Compliance requirement mapping
- Data protection and privacy controls
- Automated compliance monitoring

### Week 3: Risk Management Fundamentals
**Directory:** `Week3/`

- **databases/risk_management.sql** - Complete risk management database with risk register, assessments, and controls
- **documents/vulnerability_scan_report.xml** - Detailed vulnerability assessment report with findings and remediation
- **configs/risk_assessment_config.ini** - Risk assessment system configuration with scales and methodologies

**Learning Objectives:**
- Risk identification and assessment
- Vulnerability management processes
- Risk control implementation
- Quantitative and qualitative risk analysis

### Week 4: Compliance Management and Reporting
**Directory:** `Week4/`

- **databases/compliance_management.sql** - Comprehensive compliance management database with assessments and metrics
- **logs/audit_system.log** - Detailed audit trail and compliance monitoring logs
- **configs/compliance_monitoring.conf** - Complete compliance monitoring system configuration

**Learning Objectives:**
- Compliance assessment methodologies
- Audit trail management
- Compliance reporting and metrics
- Automated compliance monitoring

## Technical Specifications

### Database Files
All SQL files are compatible with SQLite, PostgreSQL, and MySQL databases. They include:
- Complete table structures with relationships
- Sample data representing realistic scenarios
- Indexes for optimal performance
- Views for common queries
- Comprehensive data covering multiple compliance frameworks

### Configuration Files
Configuration files are provided in multiple formats:
- **YAML** - Human-readable configuration format
- **JSON** - Structured data format for APIs
- **INI** - Traditional configuration file format
- **CONF** - System configuration format

### Log Files
Log files demonstrate:
- Structured logging formats
- Compliance-relevant events
- Audit trail requirements
- Real-time monitoring scenarios
- Security event correlation

## Usage Instructions

### Prerequisites
- Linux operating system (Ubuntu 20.04+ recommended)
- Database system (SQLite, PostgreSQL, or MySQL)
- Text editor or IDE
- Basic command-line knowledge

### Setup Instructions

1. **Extract the package:**
   ```bash
   unzip ICDFA_GRC101_Sample_Data.zip
   cd ICDFA_GRC101_Sample_Data
   ```

2. **Set up databases:**
   ```bash
   # For SQLite
   sqlite3 week1_grc.db < Week1/databases/grc_frameworks.sql
   sqlite3 week2_compliance.db < Week2/databases/regulatory_compliance.sql
   sqlite3 week3_risk.db < Week3/databases/risk_management.sql
   sqlite3 week4_compliance.db < Week4/databases/compliance_management.sql
   
   # For PostgreSQL
   psql -d grc_database -f Week1/databases/grc_frameworks.sql
   psql -d grc_database -f Week2/databases/regulatory_compliance.sql
   psql -d grc_database -f Week3/databases/risk_management.sql
   psql -d grc_database -f Week4/databases/compliance_management.sql
   ```

3. **Review configuration files:**
   ```bash
   # View configuration files
   cat Week1/configs/grc_system_config.yaml
   cat Week2/configs/gdpr_compliance_config.json
   cat Week3/configs/risk_assessment_config.ini
   cat Week4/configs/compliance_monitoring.conf
   ```

4. **Analyze log files:**
   ```bash
   # View log files
   tail -f Week2/logs/compliance_audit.log
   tail -f Week4/logs/audit_system.log
   ```

### Laboratory Exercises

#### Week 1 Exercises
- Import and explore GRC frameworks database
- Analyze organizational governance structures
- Configure GRC system parameters
- Develop policy templates

#### Week 2 Exercises
- Set up regulatory compliance monitoring
- Configure GDPR compliance system
- Analyze compliance audit logs
- Implement data protection controls

#### Week 3 Exercises
- Import risk management database
- Analyze vulnerability scan reports
- Configure risk assessment parameters
- Implement risk controls and mitigation

#### Week 4 Exercises
- Set up compliance management system
- Configure automated monitoring
- Analyze audit trails and logs
- Generate compliance reports

## Data Characteristics

### Realistic Scenarios
All sample data represents realistic organizational scenarios including:
- Multi-national corporation with 5,000+ employees
- Healthcare, financial services, and e-commerce operations
- Multiple regulatory requirements (GDPR, HIPAA, PCI DSS, SOX)
- Complex IT infrastructure with cloud and on-premises systems

### Compliance Frameworks Covered
- **SOX** - Sarbanes-Oxley Act financial controls
- **GDPR** - General Data Protection Regulation
- **HIPAA** - Health Insurance Portability and Accountability Act
- **PCI DSS** - Payment Card Industry Data Security Standard
- **ISO 27001** - Information Security Management Systems
- **NIST CSF** - NIST Cybersecurity Framework

### Data Volume
- **1,000+** sample records across all databases
- **50+** configuration parameters per system
- **500+** log entries demonstrating various scenarios
- **25+** policy templates and documents

## Security Considerations

### Data Classification
- All sample data is **FICTIONAL** and safe for educational use
- No real personal data, financial information, or sensitive details
- Designed to simulate realistic scenarios without actual risk

### Best Practices Demonstrated
- Encryption configuration examples
- Access control implementations
- Audit trail requirements
- Data retention policies
- Privacy by design principles

## Integration with Course Materials

### Alignment with Learning Objectives
Each week's sample data directly supports the corresponding course learning objectives:
- **Week 1:** GRC fundamentals and framework implementation
- **Week 2:** Regulatory compliance and standards
- **Week 3:** Risk management and assessment
- **Week 4:** Compliance management and reporting

### Hands-on Learning
Sample data enables practical exercises including:
- Database queries and analysis
- Configuration file modification
- Log file analysis and correlation
- Report generation and interpretation
- System integration and automation

## Troubleshooting

### Common Issues

1. **Database Import Errors**
   - Ensure proper database permissions
   - Check SQL syntax compatibility
   - Verify database version requirements

2. **Configuration File Errors**
   - Validate JSON/YAML syntax
   - Check file permissions
   - Verify path references

3. **Log File Analysis**
   - Use appropriate text processing tools
   - Consider log rotation and timestamps
   - Apply proper filtering techniques

### Support Resources
- Course instructor and teaching assistants
- ICDFA online learning platform
- Community forums and discussion boards
- Technical documentation and references

## Version Information

- **Package Version:** 1.0
- **Creation Date:** January 2024
- **Last Updated:** January 2024
- **Compatibility:** Linux systems, multiple database platforms
- **Course Version:** GRC101 v2024.1

## License and Usage

This sample data package is provided for educational purposes as part of the ICDFA GRC101 course. It may be used for:
- Course laboratory exercises
- Student practice and learning
- Educational research and development
- Training and certification preparation

**Restrictions:**
- Not for commercial use without permission
- Not for production system implementation
- Must maintain educational context attribution

## Contact Information

For questions, issues, or feedback regarding this sample data package:

- **Course Instructor:** [Instructor Name]
- **ICDFA Support:** support@icdfa.org
- **Technical Issues:** technical-support@icdfa.org
- **Course Website:** https://www.icdfa.org/courses/grc101

---

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
*Advancing Cybersecurity Education and Professional Development*

© 2024 ICDFA. All rights reserved.

