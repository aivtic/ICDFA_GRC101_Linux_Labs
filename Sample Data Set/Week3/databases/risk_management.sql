-- ICDFA GRC101 Week 3 Sample Database
-- Risk Management Fundamentals and Assessment
-- Sample data for risk management exercises

-- Create Risk Categories table
CREATE TABLE IF NOT EXISTS risk_categories (
    category_id TEXT PRIMARY KEY,
    category_name TEXT NOT NULL,
    category_description TEXT,
    parent_category TEXT,
    risk_appetite_level TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category) REFERENCES risk_categories (category_id)
);

-- Create Risk Register table
CREATE TABLE IF NOT EXISTS risk_register (
    risk_id TEXT PRIMARY KEY,
    risk_title TEXT NOT NULL,
    risk_description TEXT NOT NULL,
    risk_category TEXT NOT NULL,
    risk_owner TEXT NOT NULL,
    business_unit TEXT,
    identified_date DATE,
    last_review_date DATE,
    next_review_date DATE,
    risk_status TEXT DEFAULT 'ACTIVE',
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (risk_category) REFERENCES risk_categories (category_id)
);

-- Create Risk Assessments table
CREATE TABLE IF NOT EXISTS risk_assessments (
    assessment_id TEXT PRIMARY KEY,
    risk_id TEXT NOT NULL,
    assessment_date DATE NOT NULL,
    assessor TEXT NOT NULL,
    inherent_likelihood INTEGER NOT NULL,
    inherent_impact INTEGER NOT NULL,
    inherent_risk_score INTEGER NOT NULL,
    residual_likelihood INTEGER,
    residual_impact INTEGER,
    residual_risk_score INTEGER,
    risk_level TEXT,
    assessment_notes TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (risk_id) REFERENCES risk_register (risk_id)
);

-- Create Risk Controls table
CREATE TABLE IF NOT EXISTS risk_controls (
    control_id TEXT PRIMARY KEY,
    risk_id TEXT NOT NULL,
    control_name TEXT NOT NULL,
    control_type TEXT NOT NULL,
    control_description TEXT NOT NULL,
    control_owner TEXT NOT NULL,
    implementation_status TEXT NOT NULL,
    effectiveness_rating INTEGER,
    testing_frequency TEXT,
    last_test_date DATE,
    next_test_date DATE,
    test_results TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (risk_id) REFERENCES risk_register (risk_id)
);

-- Create Vulnerabilities table
CREATE TABLE IF NOT EXISTS vulnerabilities (
    vulnerability_id TEXT PRIMARY KEY,
    vulnerability_name TEXT NOT NULL,
    cve_id TEXT,
    cvss_score REAL,
    severity_level TEXT NOT NULL,
    affected_systems TEXT NOT NULL,
    vulnerability_description TEXT NOT NULL,
    discovery_date DATE,
    disclosure_date DATE,
    patch_available BOOLEAN DEFAULT FALSE,
    patch_date DATE,
    remediation_status TEXT DEFAULT 'OPEN',
    remediation_plan TEXT,
    remediation_deadline DATE,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Threat Intelligence table
CREATE TABLE IF NOT EXISTS threat_intelligence (
    threat_id TEXT PRIMARY KEY,
    threat_name TEXT NOT NULL,
    threat_type TEXT NOT NULL,
    threat_actor TEXT,
    threat_description TEXT NOT NULL,
    attack_vectors TEXT,
    indicators_of_compromise TEXT,
    mitigation_strategies TEXT,
    threat_level TEXT,
    first_observed DATE,
    last_observed DATE,
    intelligence_source TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Risk Incidents table
CREATE TABLE IF NOT EXISTS risk_incidents (
    incident_id TEXT PRIMARY KEY,
    risk_id TEXT,
    incident_title TEXT NOT NULL,
    incident_description TEXT NOT NULL,
    incident_date DATE NOT NULL,
    discovery_date DATE,
    incident_type TEXT NOT NULL,
    severity_level TEXT NOT NULL,
    financial_impact REAL,
    operational_impact TEXT,
    reputational_impact TEXT,
    incident_status TEXT DEFAULT 'OPEN',
    root_cause TEXT,
    lessons_learned TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (risk_id) REFERENCES risk_register (risk_id)
);

-- Create Risk Mitigation Plans table
CREATE TABLE IF NOT EXISTS risk_mitigation_plans (
    plan_id TEXT PRIMARY KEY,
    risk_id TEXT NOT NULL,
    mitigation_strategy TEXT NOT NULL,
    plan_description TEXT NOT NULL,
    plan_owner TEXT NOT NULL,
    start_date DATE,
    target_completion_date DATE,
    actual_completion_date DATE,
    plan_status TEXT DEFAULT 'PLANNED',
    budget_allocated REAL,
    budget_spent REAL,
    success_criteria TEXT,
    progress_notes TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (risk_id) REFERENCES risk_register (risk_id)
);

-- Insert sample risk categories
INSERT INTO risk_categories VALUES 
('CYBER', 'Cybersecurity Risk', 'Risks related to information security and cyber threats', NULL, 'LOW', datetime('now')),
('CYBER_DATA', 'Data Security', 'Risks related to data breaches and data protection', 'CYBER', 'VERY_LOW', datetime('now')),
('CYBER_INFRA', 'Infrastructure Security', 'Risks related to IT infrastructure security', 'CYBER', 'LOW', datetime('now')),
('CYBER_APP', 'Application Security', 'Risks related to application vulnerabilities', 'CYBER', 'LOW', datetime('now')),
('OPERATIONAL', 'Operational Risk', 'Risks related to business operations and processes', NULL, 'MEDIUM', datetime('now')),
('OP_PROCESS', 'Process Risk', 'Risks related to business process failures', 'OPERATIONAL', 'MEDIUM', datetime('now')),
('OP_PEOPLE', 'People Risk', 'Risks related to human resources and personnel', 'OPERATIONAL', 'MEDIUM', datetime('now')),
('FINANCIAL', 'Financial Risk', 'Risks related to financial losses and market conditions', NULL, 'MEDIUM', datetime('now')),
('FIN_CREDIT', 'Credit Risk', 'Risks related to credit defaults and counterparty risk', 'FINANCIAL', 'MEDIUM', datetime('now')),
('FIN_MARKET', 'Market Risk', 'Risks related to market volatility and price changes', 'FINANCIAL', 'HIGH', datetime('now')),
('COMPLIANCE', 'Compliance Risk', 'Risks related to regulatory compliance and legal issues', NULL, 'LOW', datetime('now')),
('COMP_REG', 'Regulatory Risk', 'Risks related to regulatory changes and violations', 'COMPLIANCE', 'LOW', datetime('now')),
('STRATEGIC', 'Strategic Risk', 'Risks related to strategic decisions and market position', NULL, 'HIGH', datetime('now')),
('STRAT_COMP', 'Competitive Risk', 'Risks related to competitive pressures and market share', 'STRATEGIC', 'HIGH', datetime('now')),
('REPUTATION', 'Reputational Risk', 'Risks related to brand reputation and public perception', NULL, 'MEDIUM', datetime('now'));

-- Insert sample risks
INSERT INTO risk_register VALUES 
('RISK_001', 'Data Breach - Customer Database', 'Risk of unauthorized access to customer personal data', 'CYBER_DATA', 'CISO', 'IT Department', '2024-01-15', '2024-01-15', '2024-04-15', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_002', 'Ransomware Attack', 'Risk of ransomware infection affecting critical systems', 'CYBER_INFRA', 'IT Security Manager', 'IT Department', '2024-01-10', '2024-01-10', '2024-04-10', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_003', 'SQL Injection Vulnerability', 'Risk of SQL injection attacks on web applications', 'CYBER_APP', 'Application Security Lead', 'Development', '2024-01-20', '2024-01-20', '2024-04-20', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_004', 'Key Personnel Departure', 'Risk of critical staff leaving the organization', 'OP_PEOPLE', 'HR Director', 'Human Resources', '2024-01-05', '2024-01-05', '2024-04-05', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_005', 'Supply Chain Disruption', 'Risk of critical supplier failure or disruption', 'OP_PROCESS', 'Procurement Manager', 'Operations', '2024-01-12', '2024-01-12', '2024-04-12', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_006', 'Credit Default by Major Customer', 'Risk of payment default by key customer', 'FIN_CREDIT', 'CFO', 'Finance', '2024-01-08', '2024-01-08', '2024-04-08', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_007', 'Regulatory Compliance Violation', 'Risk of violating GDPR or other regulations', 'COMP_REG', 'Compliance Officer', 'Legal & Compliance', '2024-01-18', '2024-01-18', '2024-04-18', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_008', 'Market Share Loss to Competitors', 'Risk of losing market position to new competitors', 'STRAT_COMP', 'CEO', 'Executive', '2024-01-25', '2024-01-25', '2024-04-25', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_009', 'Public Relations Crisis', 'Risk of negative publicity affecting brand reputation', 'REPUTATION', 'Communications Director', 'Marketing', '2024-01-22', '2024-01-22', '2024-04-22', 'ACTIVE', datetime('now'), datetime('now')),
('RISK_010', 'Cloud Service Provider Outage', 'Risk of extended outage of critical cloud services', 'CYBER_INFRA', 'Cloud Architect', 'IT Department', '2024-01-30', '2024-01-30', '2024-04-30', 'ACTIVE', datetime('now'), datetime('now'));

-- Insert sample risk assessments
INSERT INTO risk_assessments VALUES 
('ASSESS_001', 'RISK_001', '2024-01-15', 'Security Analyst', 4, 5, 20, 2, 4, 8, 'MEDIUM', 'Strong controls in place, residual risk acceptable', datetime('now')),
('ASSESS_002', 'RISK_002', '2024-01-10', 'IT Security Manager', 3, 5, 15, 2, 3, 6, 'MEDIUM', 'Backup and recovery procedures reduce impact', datetime('now')),
('ASSESS_003', 'RISK_003', '2024-01-20', 'Application Security Lead', 4, 4, 16, 2, 2, 4, 'LOW', 'Code review and testing controls effective', datetime('now')),
('ASSESS_004', 'RISK_004', '2024-01-05', 'HR Business Partner', 3, 4, 12, 2, 3, 6, 'MEDIUM', 'Succession planning and knowledge transfer in place', datetime('now')),
('ASSESS_005', 'RISK_005', '2024-01-12', 'Supply Chain Manager', 2, 4, 8, 1, 3, 3, 'LOW', 'Multiple suppliers and contingency plans established', datetime('now')),
('ASSESS_006', 'RISK_006', '2024-01-08', 'Credit Risk Analyst', 2, 5, 10, 1, 4, 4, 'LOW', 'Credit insurance and diversified customer base', datetime('now')),
('ASSESS_007', 'RISK_007', '2024-01-18', 'Compliance Analyst', 3, 4, 12, 1, 2, 2, 'LOW', 'Strong compliance program and regular monitoring', datetime('now')),
('ASSESS_008', 'RISK_008', '2024-01-25', 'Strategy Analyst', 4, 4, 16, 3, 3, 9, 'MEDIUM', 'Innovation and customer retention strategies in place', datetime('now')),
('ASSESS_009', 'RISK_009', '2024-01-22', 'PR Manager', 2, 4, 8, 1, 2, 2, 'LOW', 'Crisis communication plan and media monitoring', datetime('now')),
('ASSESS_010', 'RISK_010', '2024-01-30', 'Infrastructure Manager', 3, 4, 12, 2, 2, 4, 'LOW', 'Multi-cloud strategy and disaster recovery plans', datetime('now'));

-- Insert sample risk controls
INSERT INTO risk_controls VALUES 
('CTRL_001', 'RISK_001', 'Database Encryption', 'Technical', 'Encrypt customer database with AES-256 encryption', 'Database Administrator', 'IMPLEMENTED', 9, 'Monthly', '2024-01-15', '2024-02-15', 'EFFECTIVE', datetime('now')),
('CTRL_002', 'RISK_001', 'Access Control Matrix', 'Administrative', 'Role-based access control for customer data', 'Security Administrator', 'IMPLEMENTED', 8, 'Quarterly', '2024-01-15', '2024-04-15', 'EFFECTIVE', datetime('now')),
('CTRL_003', 'RISK_002', 'Endpoint Protection', 'Technical', 'Deploy advanced endpoint protection on all systems', 'IT Security Team', 'IMPLEMENTED', 8, 'Daily', '2024-01-10', '2024-01-11', 'EFFECTIVE', datetime('now')),
('CTRL_004', 'RISK_002', 'Backup and Recovery', 'Technical', 'Automated daily backups with offline storage', 'Backup Administrator', 'IMPLEMENTED', 9, 'Weekly', '2024-01-10', '2024-01-17', 'EFFECTIVE', datetime('now')),
('CTRL_005', 'RISK_003', 'Code Review Process', 'Administrative', 'Mandatory security code review for all applications', 'Development Manager', 'IMPLEMENTED', 7, 'Per Release', '2024-01-20', '2024-01-25', 'EFFECTIVE', datetime('now')),
('CTRL_006', 'RISK_003', 'Web Application Firewall', 'Technical', 'Deploy WAF to protect against injection attacks', 'Network Security Team', 'IMPLEMENTED', 8, 'Monthly', '2024-01-20', '2024-02-20', 'EFFECTIVE', datetime('now')),
('CTRL_007', 'RISK_004', 'Succession Planning', 'Administrative', 'Documented succession plans for key positions', 'HR Manager', 'PARTIALLY_IMPLEMENTED', 6, 'Annually', '2024-01-05', '2024-01-05', 'NEEDS_IMPROVEMENT', datetime('now')),
('CTRL_008', 'RISK_004', 'Knowledge Management', 'Administrative', 'Comprehensive documentation and knowledge sharing', 'Knowledge Manager', 'IMPLEMENTED', 7, 'Quarterly', '2024-01-05', '2024-04-05', 'EFFECTIVE', datetime('now')),
('CTRL_009', 'RISK_005', 'Supplier Diversification', 'Strategic', 'Maintain multiple suppliers for critical components', 'Procurement Manager', 'IMPLEMENTED', 8, 'Semi-annually', '2024-01-12', '2024-07-12', 'EFFECTIVE', datetime('now')),
('CTRL_010', 'RISK_006', 'Credit Insurance', 'Financial', 'Credit insurance for major customer accounts', 'Finance Manager', 'IMPLEMENTED', 9, 'Annually', '2024-01-08', '2025-01-08', 'EFFECTIVE', datetime('now'));

-- Insert sample vulnerabilities
INSERT INTO vulnerabilities VALUES 
('VUL_001', 'Apache Log4j Remote Code Execution', 'CVE-2021-44228', 10.0, 'CRITICAL', 'Web servers, application servers', 'Remote code execution vulnerability in Apache Log4j library', '2021-12-09', '2021-12-10', TRUE, '2021-12-13', 'PATCHED', 'All systems patched and verified', '2021-12-20', datetime('now')),
('VUL_002', 'Windows Print Spooler Elevation of Privilege', 'CVE-2021-34527', 8.8, 'HIGH', 'Windows servers and workstations', 'Local privilege escalation vulnerability in Windows Print Spooler', '2021-06-29', '2021-07-01', TRUE, '2021-07-06', 'PATCHED', 'Security updates applied to all Windows systems', '2021-07-15', datetime('now')),
('VUL_003', 'SQL Server Remote Code Execution', 'CVE-2023-21528', 8.8, 'HIGH', 'Database servers', 'Remote code execution vulnerability in Microsoft SQL Server', '2023-02-14', '2023-02-14', TRUE, '2023-02-14', 'PATCHED', 'Database servers updated with latest patches', '2023-02-20', datetime('now')),
('VUL_004', 'Weak SSL/TLS Configuration', NULL, 5.3, 'MEDIUM', 'Web applications', 'Weak SSL/TLS cipher suites and protocols enabled', '2024-01-15', '2024-01-15', FALSE, NULL, 'IN_PROGRESS', 'Updating SSL/TLS configuration across all web services', '2024-02-15', datetime('now')),
('VUL_005', 'Outdated WordPress Plugin', 'CVE-2023-45124', 7.5, 'HIGH', 'Corporate website', 'Cross-site scripting vulnerability in WordPress contact form plugin', '2024-01-10', '2024-01-10', TRUE, '2024-01-12', 'PATCHED', 'Plugin updated to latest version', '2024-01-15', datetime('now')),
('VUL_006', 'Unencrypted Database Connection', NULL, 6.5, 'MEDIUM', 'Application servers', 'Database connections not using SSL/TLS encryption', '2024-01-20', '2024-01-20', FALSE, NULL, 'OPEN', 'Planning to implement encrypted database connections', '2024-03-01', datetime('now')),
('VUL_007', 'Default Administrator Account', NULL, 7.8, 'HIGH', 'Network devices', 'Default administrator accounts with weak passwords', '2024-01-05', '2024-01-05', FALSE, NULL, 'IN_PROGRESS', 'Changing default passwords and disabling unused accounts', '2024-02-01', datetime('now')),
('VUL_008', 'Missing Security Headers', NULL, 4.3, 'LOW', 'Web applications', 'Missing security headers (HSTS, CSP, X-Frame-Options)', '2024-01-25', '2024-01-25', FALSE, NULL, 'OPEN', 'Implementing security headers in web server configuration', '2024-02-28', datetime('now'));

-- Insert sample threat intelligence
INSERT INTO threat_intelligence VALUES 
('THREAT_001', 'APT29 (Cozy Bear)', 'Advanced Persistent Threat', 'Russian State-Sponsored', 'Sophisticated cyber espionage group targeting government and private organizations', 'Spear phishing, supply chain attacks, cloud exploitation', 'Specific malware hashes, C2 domains, IP addresses', 'Enhanced email security, network monitoring, endpoint detection', 'HIGH', '2023-01-01', '2024-01-30', 'Government Intelligence', datetime('now')),
('THREAT_002', 'Conti Ransomware', 'Ransomware', 'Cybercriminal Group', 'Ransomware-as-a-Service operation targeting large organizations', 'Email phishing, RDP exploitation, lateral movement', 'Ransomware signatures, encryption patterns, payment wallets', 'Backup strategies, network segmentation, user training', 'HIGH', '2023-06-15', '2024-01-15', 'Threat Intelligence Feed', datetime('now')),
('THREAT_003', 'Business Email Compromise', 'Social Engineering', 'Various Actors', 'Email-based fraud targeting financial transactions and sensitive data', 'Email spoofing, social engineering, account takeover', 'Suspicious email patterns, compromised accounts, wire transfer requests', 'Email authentication, user awareness, financial controls', 'MEDIUM', '2023-01-01', '2024-01-30', 'FBI IC3', datetime('now')),
('THREAT_004', 'Supply Chain Attack', 'Supply Chain Compromise', 'Nation-State Actors', 'Compromise of software supply chain to target downstream customers', 'Software updates, third-party libraries, hardware implants', 'Compromised software signatures, malicious code patterns', 'Vendor security assessments, code signing verification', 'HIGH', '2023-03-01', '2024-01-20', 'Industry Sharing', datetime('now')),
('THREAT_005', 'Insider Threat - Data Exfiltration', 'Insider Threat', 'Malicious Insider', 'Authorized users stealing or leaking sensitive information', 'Data download, email forwarding, removable media', 'Unusual data access patterns, large file transfers, policy violations', 'Access controls, data loss prevention, user monitoring', 'MEDIUM', '2023-01-01', '2024-01-25', 'Internal Security Team', datetime('now'));

-- Insert sample risk incidents
INSERT INTO risk_incidents VALUES 
('INC_001', 'RISK_001', 'Unauthorized Database Access Attempt', 'Failed attempt to access customer database from external IP', '2024-01-12', '2024-01-12', 'Security Incident', 'MEDIUM', 0, 'No data accessed, systems temporarily unavailable', 'Minor reputational impact', 'CLOSED', 'Weak firewall rule allowed connection attempt', 'Strengthened firewall rules and monitoring', datetime('now')),
('INC_002', 'RISK_002', 'Phishing Email Campaign', 'Targeted phishing emails sent to employees with malicious attachments', '2024-01-08', '2024-01-09', 'Security Incident', 'HIGH', 15000, '3 employees clicked links, 1 system quarantined', 'Internal incident, no public disclosure', 'CLOSED', 'Insufficient user awareness training', 'Enhanced security awareness training program', datetime('now')),
('INC_003', 'RISK_004', 'Key Developer Resignation', 'Lead developer resigned with 2 weeks notice', '2024-01-15', '2024-01-15', 'Operational Incident', 'MEDIUM', 50000, 'Project delays, knowledge transfer challenges', 'No external impact', 'CLOSED', 'Lack of succession planning and documentation', 'Implemented knowledge sharing and succession planning', datetime('now')),
('INC_004', 'RISK_005', 'Supplier Delivery Delay', 'Critical component supplier experienced production delays', '2024-01-20', '2024-01-18', 'Operational Incident', 'LOW', 25000, 'Minor production delays, alternative supplier engaged', 'Customer communication required', 'CLOSED', 'Single source dependency for critical component', 'Identified and qualified backup suppliers', datetime('now')),
('INC_005', 'RISK_010', 'Cloud Service Outage', 'Primary cloud provider experienced 4-hour outage', '2024-01-25', '2024-01-25', 'Operational Incident', 'MEDIUM', 75000, 'Customer-facing services unavailable for 4 hours', 'Customer complaints and social media mentions', 'CLOSED', 'Dependency on single cloud availability zone', 'Implemented multi-zone deployment architecture', datetime('now'));

-- Insert sample risk mitigation plans
INSERT INTO risk_mitigation_plans VALUES 
('PLAN_001', 'RISK_001', 'REDUCE', 'Implement advanced data loss prevention (DLP) solution', 'IT Security Manager', '2024-02-01', '2024-04-30', NULL, 'IN_PROGRESS', 150000, 75000, 'Reduce data exfiltration risk by 80%', 'DLP solution selected, implementation 50% complete', datetime('now')),
('PLAN_002', 'RISK_002', 'REDUCE', 'Deploy next-generation endpoint detection and response (EDR)', 'Cybersecurity Team', '2024-01-15', '2024-03-15', NULL, 'IN_PROGRESS', 200000, 120000, 'Improve threat detection and response time by 70%', 'EDR deployed on 60% of endpoints', datetime('now')),
('PLAN_003', 'RISK_003', 'REDUCE', 'Implement automated security testing in CI/CD pipeline', 'DevSecOps Team', '2024-02-01', '2024-05-31', NULL, 'PLANNED', 100000, 0, 'Identify 95% of security vulnerabilities before production', 'Security testing tools evaluation in progress', datetime('now')),
('PLAN_004', 'RISK_004', 'REDUCE', 'Develop comprehensive succession planning program', 'HR Department', '2024-01-01', '2024-06-30', NULL, 'IN_PROGRESS', 75000, 25000, 'Succession plans for all critical roles', 'Succession plans completed for 40% of critical roles', datetime('now')),
('PLAN_005', 'RISK_005', 'TRANSFER', 'Obtain supply chain disruption insurance coverage', 'Risk Management', '2024-02-01', '2024-03-31', NULL, 'PLANNED', 50000, 0, 'Transfer 80% of financial impact to insurance', 'Insurance broker engaged, coverage options being evaluated', datetime('now')),
('PLAN_006', 'RISK_006', 'REDUCE', 'Implement enhanced credit monitoring and early warning system', 'Finance Team', '2024-01-15', '2024-04-15', NULL, 'IN_PROGRESS', 80000, 30000, 'Reduce credit losses by 60%', 'Credit monitoring system 40% implemented', datetime('now')),
('PLAN_007', 'RISK_007', 'REDUCE', 'Deploy automated compliance monitoring platform', 'Compliance Team', '2024-02-01', '2024-07-31', NULL, 'PLANNED', 250000, 0, 'Achieve 99% compliance monitoring coverage', 'Platform vendor selection in progress', datetime('now')),
('PLAN_008', 'RISK_008', 'ACCEPT', 'Enhance competitive intelligence and market monitoring', 'Strategy Team', '2024-01-01', '2024-12-31', NULL, 'IN_PROGRESS', 120000, 40000, 'Improve market response time by 50%', 'Competitive intelligence framework 30% complete', datetime('now'));

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_risks_category ON risk_register(risk_category);
CREATE INDEX IF NOT EXISTS idx_risks_owner ON risk_register(risk_owner);
CREATE INDEX IF NOT EXISTS idx_risks_status ON risk_register(risk_status);
CREATE INDEX IF NOT EXISTS idx_assessments_date ON risk_assessments(assessment_date);
CREATE INDEX IF NOT EXISTS idx_assessments_risk ON risk_assessments(risk_id);
CREATE INDEX IF NOT EXISTS idx_controls_risk ON risk_controls(risk_id);
CREATE INDEX IF NOT EXISTS idx_controls_status ON risk_controls(implementation_status);
CREATE INDEX IF NOT EXISTS idx_vulnerabilities_severity ON vulnerabilities(severity_level);
CREATE INDEX IF NOT EXISTS idx_vulnerabilities_status ON vulnerabilities(remediation_status);
CREATE INDEX IF NOT EXISTS idx_threats_level ON threat_intelligence(threat_level);
CREATE INDEX IF NOT EXISTS idx_incidents_date ON risk_incidents(incident_date);
CREATE INDEX IF NOT EXISTS idx_incidents_severity ON risk_incidents(severity_level);
CREATE INDEX IF NOT EXISTS idx_mitigation_status ON risk_mitigation_plans(plan_status);

-- Create views for common risk management queries
CREATE VIEW IF NOT EXISTS high_risk_items AS
SELECT r.risk_id, r.risk_title, ra.residual_risk_score, ra.risk_level
FROM risk_register r
JOIN risk_assessments ra ON r.risk_id = ra.risk_id
WHERE ra.residual_risk_score >= 12;

CREATE VIEW IF NOT EXISTS critical_vulnerabilities AS
SELECT * FROM vulnerabilities 
WHERE severity_level = 'CRITICAL' AND remediation_status != 'PATCHED';

CREATE VIEW IF NOT EXISTS overdue_mitigation_plans AS
SELECT * FROM risk_mitigation_plans 
WHERE target_completion_date < date('now') AND plan_status != 'COMPLETED';

CREATE VIEW IF NOT EXISTS risk_control_effectiveness AS
SELECT 
    r.risk_id,
    r.risk_title,
    COUNT(rc.control_id) as total_controls,
    AVG(rc.effectiveness_rating) as avg_effectiveness,
    SUM(CASE WHEN rc.implementation_status = 'IMPLEMENTED' THEN 1 ELSE 0 END) as implemented_controls
FROM risk_register r
LEFT JOIN risk_controls rc ON r.risk_id = rc.risk_id
GROUP BY r.risk_id, r.risk_title;

CREATE VIEW IF NOT EXISTS risk_heat_map AS
SELECT 
    r.risk_id,
    r.risk_title,
    r.risk_category,
    ra.residual_likelihood,
    ra.residual_impact,
    ra.residual_risk_score,
    ra.risk_level
FROM risk_register r
JOIN risk_assessments ra ON r.risk_id = ra.risk_id
WHERE r.risk_status = 'ACTIVE'
ORDER BY ra.residual_risk_score DESC;

