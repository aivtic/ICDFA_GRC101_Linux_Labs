-- ICDFA GRC101 Week 2 Sample Database
-- Regulatory Environment and Standards Compliance
-- Sample data for regulatory compliance exercises

-- Create Regulatory Frameworks table
CREATE TABLE IF NOT EXISTS regulatory_frameworks (
    regulation_id TEXT PRIMARY KEY,
    regulation_name TEXT NOT NULL,
    regulation_acronym TEXT NOT NULL,
    jurisdiction TEXT NOT NULL,
    regulatory_body TEXT NOT NULL,
    industry_sector TEXT,
    effective_date DATE,
    last_updated DATE,
    mandatory BOOLEAN DEFAULT TRUE,
    penalties_description TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Compliance Requirements table
CREATE TABLE IF NOT EXISTS compliance_requirements (
    requirement_id TEXT PRIMARY KEY,
    regulation_id TEXT NOT NULL,
    requirement_number TEXT NOT NULL,
    requirement_title TEXT NOT NULL,
    requirement_description TEXT NOT NULL,
    control_category TEXT NOT NULL,
    priority_level TEXT NOT NULL,
    implementation_guidance TEXT,
    testing_procedures TEXT,
    penalty_amount INTEGER,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (regulation_id) REFERENCES regulatory_frameworks (regulation_id)
);

-- Create Compliance Assessments table
CREATE TABLE IF NOT EXISTS compliance_assessments (
    assessment_id TEXT PRIMARY KEY,
    regulation_id TEXT NOT NULL,
    assessment_date DATE NOT NULL,
    assessment_type TEXT NOT NULL,
    assessor TEXT NOT NULL,
    overall_compliance_score INTEGER,
    compliance_status TEXT,
    findings_summary TEXT,
    recommendations TEXT,
    next_assessment_date DATE,
    FOREIGN KEY (regulation_id) REFERENCES regulatory_frameworks (regulation_id)
);

-- Create GDPR Data Processing Activities table
CREATE TABLE IF NOT EXISTS gdpr_data_processing (
    processing_id TEXT PRIMARY KEY,
    activity_name TEXT NOT NULL,
    data_controller TEXT NOT NULL,
    data_processor TEXT,
    purpose_of_processing TEXT NOT NULL,
    legal_basis TEXT NOT NULL,
    data_categories TEXT NOT NULL,
    data_subjects TEXT NOT NULL,
    retention_period TEXT,
    international_transfers BOOLEAN DEFAULT FALSE,
    transfer_safeguards TEXT,
    security_measures TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create HIPAA Covered Entities table
CREATE TABLE IF NOT EXISTS hipaa_covered_entities (
    entity_id TEXT PRIMARY KEY,
    entity_name TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    business_associate BOOLEAN DEFAULT FALSE,
    phi_types TEXT NOT NULL,
    security_measures TEXT,
    privacy_measures TEXT,
    breach_notification_procedures TEXT,
    last_risk_assessment DATE,
    compliance_status TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create PCI DSS Merchant Information table
CREATE TABLE IF NOT EXISTS pci_dss_merchants (
    merchant_id TEXT PRIMARY KEY,
    merchant_name TEXT NOT NULL,
    merchant_level INTEGER NOT NULL,
    card_data_environment TEXT NOT NULL,
    annual_transaction_volume INTEGER,
    compliance_validation_type TEXT NOT NULL,
    last_assessment_date DATE,
    compliance_status TEXT,
    compensating_controls TEXT,
    remediation_plan TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create SOX Controls table
CREATE TABLE IF NOT EXISTS sox_controls (
    control_id TEXT PRIMARY KEY,
    control_name TEXT NOT NULL,
    control_type TEXT NOT NULL,
    process_area TEXT NOT NULL,
    control_description TEXT NOT NULL,
    control_owner TEXT NOT NULL,
    testing_frequency TEXT,
    last_test_date DATE,
    test_results TEXT,
    deficiencies TEXT,
    management_response TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample regulatory frameworks
INSERT INTO regulatory_frameworks VALUES 
('GDPR', 'General Data Protection Regulation', 'GDPR', 'European Union', 'European Commission', 'All Sectors', '2018-05-25', '2023-12-01', TRUE, 'Up to €20 million or 4% of annual global turnover', datetime('now')),
('HIPAA', 'Health Insurance Portability and Accountability Act', 'HIPAA', 'United States', 'Department of Health and Human Services', 'Healthcare', '1996-08-21', '2023-10-15', TRUE, 'Civil penalties up to $1.5 million per incident', datetime('now')),
('PCI_DSS', 'Payment Card Industry Data Security Standard', 'PCI DSS', 'Global', 'PCI Security Standards Council', 'Payment Processing', '2022-03-31', '2024-01-01', TRUE, 'Fines up to $100,000 per month', datetime('now')),
('SOX', 'Sarbanes-Oxley Act', 'SOX', 'United States', 'Securities and Exchange Commission', 'Public Companies', '2002-07-30', '2023-08-20', TRUE, 'Criminal penalties up to $5 million and 20 years imprisonment', datetime('now')),
('CCPA', 'California Consumer Privacy Act', 'CCPA', 'California, USA', 'California Attorney General', 'All Sectors', '2020-01-01', '2023-09-15', TRUE, 'Civil penalties up to $7,500 per violation', datetime('now')),
('PIPEDA', 'Personal Information Protection and Electronic Documents Act', 'PIPEDA', 'Canada', 'Office of the Privacy Commissioner', 'All Sectors', '2001-01-01', '2023-11-30', TRUE, 'Fines up to CAD $100,000', datetime('now'));

-- Insert sample GDPR compliance requirements
INSERT INTO compliance_requirements VALUES 
('GDPR_25', 'GDPR', 'Article 25', 'Data Protection by Design and by Default', 'Implement appropriate technical and organizational measures to ensure data protection principles', 'Privacy Engineering', 'HIGH', 'Integrate privacy into system design and default settings', 'Review system architectures and privacy controls', 20000000, datetime('now')),
('GDPR_32', 'GDPR', 'Article 32', 'Security of Processing', 'Implement appropriate technical and organizational security measures', 'Data Security', 'HIGH', 'Implement encryption, access controls, and monitoring', 'Test security controls and incident response procedures', 20000000, datetime('now')),
('GDPR_33', 'GDPR', 'Article 33', 'Notification of Personal Data Breach to Supervisory Authority', 'Notify supervisory authority of data breaches within 72 hours', 'Incident Response', 'CRITICAL', 'Establish breach notification procedures and timelines', 'Test breach notification procedures', 10000000, datetime('now')),
('GDPR_34', 'GDPR', 'Article 34', 'Communication of Personal Data Breach to Data Subject', 'Notify affected individuals of high-risk data breaches', 'Incident Response', 'HIGH', 'Develop data subject notification procedures', 'Review notification templates and procedures', 10000000, datetime('now')),
('GDPR_35', 'GDPR', 'Article 35', 'Data Protection Impact Assessment', 'Conduct DPIA for high-risk processing activities', 'Privacy Assessment', 'HIGH', 'Establish DPIA methodology and criteria', 'Review DPIA documentation and processes', 10000000, datetime('now'));

-- Insert sample HIPAA compliance requirements
INSERT INTO compliance_requirements VALUES 
('HIPAA_164_308', 'HIPAA', '164.308', 'Administrative Safeguards', 'Implement administrative safeguards to protect PHI', 'Administrative Controls', 'HIGH', 'Establish security policies and assign security responsibilities', 'Review administrative procedures and documentation', 1500000, datetime('now')),
('HIPAA_164_310', 'HIPAA', '164.310', 'Physical Safeguards', 'Implement physical safeguards to protect PHI', 'Physical Security', 'HIGH', 'Control physical access to systems containing PHI', 'Test physical access controls and monitoring', 1500000, datetime('now')),
('HIPAA_164_312', 'HIPAA', '164.312', 'Technical Safeguards', 'Implement technical safeguards to protect PHI', 'Technical Controls', 'HIGH', 'Implement access controls, encryption, and audit logs', 'Test technical controls and monitoring systems', 1500000, datetime('now')),
('HIPAA_164_502', 'HIPAA', '164.502', 'Uses and Disclosures of PHI', 'Limit uses and disclosures of PHI to minimum necessary', 'Data Governance', 'HIGH', 'Establish minimum necessary policies and procedures', 'Review PHI access and disclosure practices', 1000000, datetime('now'));

-- Insert sample PCI DSS compliance requirements
INSERT INTO compliance_requirements VALUES 
('PCI_1', 'PCI_DSS', '1', 'Install and Maintain Network Security Controls', 'Install and maintain network security controls', 'Network Security', 'CRITICAL', 'Implement firewalls and network segmentation', 'Test firewall configurations and network controls', 100000, datetime('now')),
('PCI_2', 'PCI_DSS', '2', 'Apply Secure Configurations to All System Components', 'Apply secure configurations to all system components', 'System Hardening', 'HIGH', 'Implement secure configuration standards', 'Review system configurations and hardening', 100000, datetime('now')),
('PCI_3', 'PCI_DSS', '3', 'Protect Stored Account Data', 'Protect stored cardholder data', 'Data Protection', 'CRITICAL', 'Implement encryption and data protection controls', 'Test encryption and data protection measures', 100000, datetime('now')),
('PCI_4', 'PCI_DSS', '4', 'Protect Cardholder Data with Strong Cryptography', 'Protect cardholder data transmission with strong cryptography', 'Encryption', 'CRITICAL', 'Implement strong encryption for data transmission', 'Test encryption protocols and key management', 100000, datetime('now'));

-- Insert sample SOX compliance requirements
INSERT INTO compliance_requirements VALUES 
('SOX_302', 'SOX', '302', 'Corporate Responsibility for Financial Reports', 'Principal executive and financial officers must certify financial reports', 'Financial Reporting', 'CRITICAL', 'Implement certification process and controls', 'Review certification documentation and processes', 5000000, datetime('now')),
('SOX_404', 'SOX', '404', 'Management Assessment of Internal Controls', 'Management must assess and report on internal control over financial reporting', 'Internal Controls', 'CRITICAL', 'Establish ICFR assessment framework', 'Test control design and operating effectiveness', 5000000, datetime('now')),
('SOX_409', 'SOX', '409', 'Real Time Issuer Disclosures', 'Rapid and current disclosure of material changes in financial condition', 'Disclosure Controls', 'HIGH', 'Implement disclosure controls and procedures', 'Test disclosure processes and timelines', 2000000, datetime('now'));

-- Insert sample GDPR data processing activities
INSERT INTO gdpr_data_processing VALUES 
('PROC_001', 'Employee HR Management', 'ACME Corporation', NULL, 'Human resources management and payroll processing', 'Contract (Article 6(1)(b))', 'Personal identifiers, employment data, financial data', 'Employees, job applicants', '7 years after employment termination', FALSE, NULL, 'Encryption, access controls, audit logging', datetime('now'), datetime('now')),
('PROC_002', 'Customer Relationship Management', 'ACME Corporation', 'CRM Solutions Inc.', 'Customer service and relationship management', 'Legitimate interests (Article 6(1)(f))', 'Contact information, transaction history, preferences', 'Customers, prospects', '5 years after last interaction', FALSE, NULL, 'Pseudonymization, encryption, access controls', datetime('now'), datetime('now')),
('PROC_003', 'Marketing Communications', 'ACME Corporation', 'Marketing Agency Ltd.', 'Direct marketing and promotional communications', 'Consent (Article 6(1)(a))', 'Contact information, preferences, behavioral data', 'Customers, subscribers', 'Until consent withdrawn', FALSE, NULL, 'Encryption, consent management, opt-out mechanisms', datetime('now'), datetime('now')),
('PROC_004', 'Financial Transaction Processing', 'ACME Corporation', 'Payment Processor Co.', 'Processing payments and financial transactions', 'Contract (Article 6(1)(b))', 'Financial data, transaction details, identification', 'Customers', '7 years for tax purposes', TRUE, 'Standard Contractual Clauses', 'Strong encryption, tokenization, fraud monitoring', datetime('now'), datetime('now'));

-- Insert sample HIPAA covered entities
INSERT INTO hipaa_covered_entities VALUES 
('CE_001', 'General Hospital', 'Healthcare Provider', FALSE, 'Medical records, treatment information, billing data', 'Encryption, access controls, audit logs, physical security', 'Privacy policies, patient rights, minimum necessary', 'Breach notification within 60 days', '2024-01-15', 'COMPLIANT', datetime('now')),
('CE_002', 'Health Insurance Company', 'Health Plan', FALSE, 'Claims data, member information, medical history', 'Data encryption, secure transmission, access monitoring', 'Privacy notices, individual rights, complaint procedures', 'Breach notification within 60 days', '2024-01-10', 'COMPLIANT', datetime('now')),
('CE_003', 'Medical Billing Service', 'Healthcare Clearinghouse', TRUE, 'Claims processing, eligibility verification, payment data', 'Secure data transmission, access controls, audit trails', 'Business associate agreement compliance', 'Breach notification within 60 days', '2024-01-20', 'PARTIALLY_COMPLIANT', datetime('now')),
('CE_004', 'Electronic Health Records Vendor', 'Business Associate', TRUE, 'Electronic health records, patient data, clinical information', 'End-to-end encryption, role-based access, data backup', 'Privacy by design, data minimization, patient consent', 'Breach notification within 60 days', '2024-01-05', 'COMPLIANT', datetime('now'));

-- Insert sample PCI DSS merchants
INSERT INTO pci_dss_merchants VALUES 
('MERCH_001', 'E-commerce Retailer', 1, 'Web application, payment gateway, database', 6000000, 'Report on Compliance (ROC)', '2024-01-15', 'COMPLIANT', NULL, NULL, datetime('now')),
('MERCH_002', 'Restaurant Chain', 2, 'Point-of-sale systems, payment terminals', 2500000, 'Self-Assessment Questionnaire (SAQ)', '2024-01-10', 'COMPLIANT', NULL, NULL, datetime('now')),
('MERCH_003', 'Small Retail Store', 4, 'Card-present transactions only', 15000, 'Self-Assessment Questionnaire (SAQ)', '2024-01-20', 'NON_COMPLIANT', 'Network segmentation, encryption', 'Implement network segmentation by Q2 2024', datetime('now')),
('MERCH_004', 'Online Marketplace', 1, 'Web application, third-party processors, stored data', 12000000, 'Report on Compliance (ROC)', '2024-01-05', 'PARTIALLY_COMPLIANT', 'Enhanced logging, vulnerability management', 'Address logging gaps by Q1 2024', datetime('now'));

-- Insert sample SOX controls
INSERT INTO sox_controls VALUES 
('SOX_CTRL_001', 'Financial Close Process', 'Process Control', 'Financial Reporting', 'Monthly financial close process with management review', 'Controller', 'Monthly', '2024-01-15', 'EFFECTIVE', NULL, NULL, datetime('now')),
('SOX_CTRL_002', 'Revenue Recognition', 'Application Control', 'Revenue', 'Automated controls for revenue recognition in ERP system', 'Revenue Manager', 'Continuous', '2024-01-10', 'EFFECTIVE', NULL, NULL, datetime('now')),
('SOX_CTRL_003', 'Access Controls - Financial Systems', 'IT General Control', 'Access Management', 'User access controls for financial reporting systems', 'IT Security Manager', 'Quarterly', '2024-01-20', 'DEFICIENT', 'Excessive privileged access identified', 'Remove unnecessary access by February 2024', datetime('now')),
('SOX_CTRL_004', 'Change Management - Financial Applications', 'IT General Control', 'Change Management', 'Change management process for financial applications', 'IT Manager', 'Continuous', '2024-01-05', 'EFFECTIVE', NULL, NULL, datetime('now')),
('SOX_CTRL_005', 'Backup and Recovery - Financial Data', 'IT General Control', 'Data Management', 'Backup and recovery procedures for financial data', 'Database Administrator', 'Daily', '2024-01-25', 'EFFECTIVE', NULL, NULL, datetime('now'));

-- Insert sample compliance assessments
INSERT INTO compliance_assessments VALUES 
('ASSESS_001', 'GDPR', '2024-01-15', 'Internal Assessment', 'Privacy Officer', 85, 'PARTIALLY_COMPLIANT', 'Good privacy controls in place, some gaps in data subject rights implementation', 'Implement automated data subject request handling', '2024-07-15'),
('ASSESS_002', 'HIPAA', '2024-01-10', 'External Assessment', 'Third-party Auditor', 92, 'COMPLIANT', 'Strong security and privacy controls, minor documentation gaps', 'Update risk assessment documentation', '2025-01-10'),
('ASSESS_003', 'PCI_DSS', '2024-01-20', 'QSA Assessment', 'Qualified Security Assessor', 78, 'NON_COMPLIANT', 'Network segmentation issues, vulnerability management gaps', 'Implement network segmentation and enhance vulnerability scanning', '2024-04-20'),
('ASSESS_004', 'SOX', '2024-01-05', 'Internal Assessment', 'Internal Audit', 88, 'PARTIALLY_COMPLIANT', 'Most controls effective, some IT general control deficiencies', 'Remediate access control and change management issues', '2024-04-05');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_regulations_jurisdiction ON regulatory_frameworks(jurisdiction);
CREATE INDEX IF NOT EXISTS idx_requirements_regulation ON compliance_requirements(regulation_id);
CREATE INDEX IF NOT EXISTS idx_assessments_date ON compliance_assessments(assessment_date);
CREATE INDEX IF NOT EXISTS idx_gdpr_controller ON gdpr_data_processing(data_controller);
CREATE INDEX IF NOT EXISTS idx_hipaa_type ON hipaa_covered_entities(entity_type);
CREATE INDEX IF NOT EXISTS idx_pci_level ON pci_dss_merchants(merchant_level);
CREATE INDEX IF NOT EXISTS idx_sox_type ON sox_controls(control_type);

-- Create views for common regulatory queries
CREATE VIEW IF NOT EXISTS high_risk_requirements AS
SELECT * FROM compliance_requirements WHERE priority_level = 'CRITICAL';

CREATE VIEW IF NOT EXISTS non_compliant_assessments AS
SELECT * FROM compliance_assessments WHERE compliance_status = 'NON_COMPLIANT';

CREATE VIEW IF NOT EXISTS gdpr_high_risk_processing AS
SELECT * FROM gdpr_data_processing WHERE international_transfers = TRUE;

CREATE VIEW IF NOT EXISTS deficient_sox_controls AS
SELECT * FROM sox_controls WHERE test_results = 'DEFICIENT';

CREATE VIEW IF NOT EXISTS regulatory_compliance_summary AS
SELECT 
    rf.regulation_name,
    COUNT(ca.assessment_id) as total_assessments,
    AVG(ca.overall_compliance_score) as avg_compliance_score,
    MAX(ca.assessment_date) as last_assessment_date
FROM regulatory_frameworks rf
LEFT JOIN compliance_assessments ca ON rf.regulation_id = ca.regulation_id
GROUP BY rf.regulation_id, rf.regulation_name;

