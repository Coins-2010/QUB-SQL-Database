-- phpMyAdmin SQL Dump
-- version 4.4.15.9
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 12, 2018 at 07:06 PM
-- Server version: 5.5.52-MariaDB
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Wombat HR`
--

-- --------------------------------------------------------

--
-- Table structure for table `Assignment`
--

CREATE TABLE IF NOT EXISTS `Assignment` (
  `ProjectID` bigint(20) NOT NULL COMMENT 'Project ID FK on Project.ProjectID',
  `EmployeeID` bigint(20) NOT NULL COMMENT 'Employee ID FK on Employee.EmployeeID'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Contract`
--

CREATE TABLE IF NOT EXISTS `Contract` (
  `ContractID` bigint(20) NOT NULL COMMENT 'AUTO_INCREMENT Contract ID PK',
  `Title` varchar(255) NOT NULL COMMENT 'Title of employment contract',
  `Start` date NOT NULL COMMENT 'Date begun',
  `DueFinish` date DEFAULT NULL COMMENT 'Date due to finish',
  `ActualFinish` date DEFAULT NULL COMMENT 'Actual date finished',
  `EmployeeID` bigint(20) NOT NULL COMMENT 'FK EmployeeID on Employee.EmployeeID'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Employee`
--

CREATE TABLE IF NOT EXISTS `Employee` (
  `EmployeeID` bigint(20) NOT NULL COMMENT 'AUTO_INCREMENT Employee ID',
  `Title` varchar(32) DEFAULT NULL COMMENT 'Title of Employee',
  `FirstName` varchar(255) NOT NULL COMMENT 'First Name',
  `LastName` varchar(255) NOT NULL COMMENT 'Last Name',
  `Email` varchar(255) DEFAULT NULL COMMENT 'Work email address',
  `Joined` date DEFAULT NULL COMMENT 'Start Date',
  `Left` date DEFAULT NULL COMMENT 'Finish date (ex employees)',
  `Current` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Current employee flag',
  `Phone` varchar(32) NOT NULL COMMENT 'Phone number',
  `GradeID` int(11) NOT NULL COMMENT 'FK GradeID on Grade.GradeID',
  `Manager` bigint(20) DEFAULT NULL COMMENT 'FK Manager on Employee.EmployeeID'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `EmployeeSkill`
--

CREATE TABLE IF NOT EXISTS `EmployeeSkill` (
  `EmployeeID` bigint(20) NOT NULL COMMENT 'Employee ID FK on Employee.EmployeeID',
  `SkillID` bigint(20) NOT NULL COMMENT 'Skill ID FK on Skill.SkillID',
  `DateAchieved` date DEFAULT NULL COMMENT 'Date skill was achieved'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Equipment`
--

CREATE TABLE IF NOT EXISTS `Equipment` (
  `EquipmentID` bigint(20) NOT NULL COMMENT 'AUTO_INCREMENT primary key',
  `Type` varchar(255) NOT NULL COMMENT 'Type of Equipment',
  `Make` varchar(255) DEFAULT NULL COMMENT 'Manufacturer',
  `Model` varchar(255) DEFAULT NULL COMMENT 'Model',
  `Description` varchar(255) DEFAULT NULL COMMENT 'Description of Item',
  `OperationNotes` text COMMENT 'Specific operation notes',
  `Damaged` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Damaged flag (not available for loan)'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `EquipmentLoan`
--

CREATE TABLE IF NOT EXISTS `EquipmentLoan` (
  `EmployeeID` bigint(20) NOT NULL,
  `EquipmentID` bigint(20) NOT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date DEFAULT NULL,
  `Current` tinyint(1) NOT NULL DEFAULT '1',
  `Notes` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Expense`
--

CREATE TABLE IF NOT EXISTS `Expense` (
  `ExpenseID` bigint(20) NOT NULL COMMENT 'AUTO_INCREMENT primary key',
  `EmployeeID` bigint(20) NOT NULL COMMENT 'FK EmployeeID on Employee.EmployeeID',
  `ProjectID` bigint(20) DEFAULT NULL COMMENT 'FK ProjectID on Project.ProjectID',
  `Description` varchar(255) NOT NULL COMMENT 'Description of Expense',
  `Amount` double NOT NULL COMMENT 'Amount of Expense',
  `Paid` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Expense paid to employee flag'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `FileItem`
--

CREATE TABLE IF NOT EXISTS `FileItem` (
  `ItemID` bigint(20) NOT NULL COMMENT 'AUTO_INCREMENT primary key',
  `Title` varchar(255) COLLATE latin1_general_ci NOT NULL DEFAULT '' COMMENT 'Title of the item stored',
  `Location` varchar(255) COLLATE latin1_general_ci NOT NULL DEFAULT '' COMMENT 'Location of the Item (where stored)',
  `EmployeeID` bigint(20) NOT NULL COMMENT 'Employee ID FK on Employee.EmployeeID'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Grade`
--

CREATE TABLE IF NOT EXISTS `Grade` (
  `GradeID` int(11) NOT NULL COMMENT 'AUTO_INCREMENT ID for the grade',
  `Title` varchar(128) NOT NULL COMMENT 'Title for the grade',
  `Code` varchar(16) NOT NULL COMMENT 'Short code for the grade',
  `SpineMin` int(11) NOT NULL DEFAULT '1' COMMENT 'Minimum spine point',
  `SpineMax` int(11) NOT NULL DEFAULT '1' COMMENT 'maximum spine point'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Payslip`
--

CREATE TABLE IF NOT EXISTS `Payslip` (
  `PayslipID` bigint(20) NOT NULL COMMENT 'AUTO_INCREMENT primary key',
  `EmployeeID` bigint(20) NOT NULL COMMENT 'FK EmployeeID on Employee.EmployeeID',
  `Taxable` double NOT NULL DEFAULT '0' COMMENT 'Taxable income',
  `NonTaxable` double NOT NULL DEFAULT '0' COMMENT 'Non-table payments (expenses etc)',
  `IncomeTax` double NOT NULL DEFAULT '0' COMMENT 'Income tax deducted',
  `NationalInsurance` double NOT NULL DEFAULT '0' COMMENT 'National Insurance deducted',
  `NetPay` double NOT NULL DEFAULT '0' COMMENT 'Net Pay (payment made)',
  `Payday` date NOT NULL COMMENT 'Payday for tax period',
  `TransferDay` date NOT NULL COMMENT 'Date payment actually made',
  `TransferRef` varchar(32) NOT NULL COMMENT 'Payment reference'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Project`
--

CREATE TABLE IF NOT EXISTS `Project` (
  `ProjectID` bigint(20) NOT NULL COMMENT 'AUTO_INCREMENT Project ID',
  `Title` varchar(255) NOT NULL COMMENT 'Project Title',
  `Notes` text COMMENT 'Project Notes / Description',
  `Internal` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Internal project flag',
  `Sensitive` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Is a sensitive / confidential project',
  `Started` date NOT NULL COMMENT 'Date project started',
  `Ended` date DEFAULT NULL COMMENT 'Date project ended (or NULL)'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Skill`
--

CREATE TABLE IF NOT EXISTS `Skill` (
  `SkillID` bigint(20) NOT NULL COMMENT 'AUTO_INCREMENT Skill ID',
  `Title` varchar(255) NOT NULL COMMENT 'Title of Skill'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Assignment`
--
ALTER TABLE `Assignment`
  ADD KEY `ProjectID` (`ProjectID`,`EmployeeID`),
  ADD KEY `EmployeeID` (`EmployeeID`);

--
-- Indexes for table `Contract`
--
ALTER TABLE `Contract`
  ADD PRIMARY KEY (`ContractID`),
  ADD KEY `Title` (`Title`),
  ADD KEY `EmployeeID` (`EmployeeID`);

--
-- Indexes for table `Employee`
--
ALTER TABLE `Employee`
  ADD PRIMARY KEY (`EmployeeID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `Manager` (`Manager`),
  ADD KEY `FirstName` (`FirstName`),
  ADD KEY `LastName` (`LastName`),
  ADD KEY `Current` (`Current`),
  ADD KEY `GradeID` (`GradeID`);

--
-- Indexes for table `EmployeeSkill`
--
ALTER TABLE `EmployeeSkill`
  ADD KEY `EmployeeID` (`EmployeeID`),
  ADD KEY `SkillID` (`SkillID`);

--
-- Indexes for table `Equipment`
--
ALTER TABLE `Equipment`
  ADD PRIMARY KEY (`EquipmentID`),
  ADD KEY `Type` (`Type`),
  ADD KEY `Model` (`Model`),
  ADD KEY `Description` (`Description`),
  ADD KEY `Damaged` (`Damaged`);

--
-- Indexes for table `EquipmentLoan`
--
ALTER TABLE `EquipmentLoan`
  ADD KEY `StartDate` (`StartDate`),
  ADD KEY `EndDate` (`EndDate`),
  ADD KEY `Current` (`Current`),
  ADD KEY `EquipmentID` (`EquipmentID`),
  ADD KEY `EmployeeID` (`EmployeeID`,`EquipmentID`) USING BTREE;

--
-- Indexes for table `Expense`
--
ALTER TABLE `Expense`
  ADD PRIMARY KEY (`ExpenseID`),
  ADD KEY `EmployeeID` (`EmployeeID`),
  ADD KEY `ProjectID` (`ProjectID`),
  ADD KEY `Description` (`Description`);

--
-- Indexes for table `FileItem`
--
ALTER TABLE `FileItem`
  ADD PRIMARY KEY (`ItemID`),
  ADD KEY `Title` (`Title`),
  ADD KEY `EmployeeID` (`EmployeeID`);

--
-- Indexes for table `Grade`
--
ALTER TABLE `Grade`
  ADD PRIMARY KEY (`GradeID`),
  ADD UNIQUE KEY `Code` (`Code`);

--
-- Indexes for table `Payslip`
--
ALTER TABLE `Payslip`
  ADD PRIMARY KEY (`PayslipID`),
  ADD KEY `EmployeeID` (`EmployeeID`);

--
-- Indexes for table `Project`
--
ALTER TABLE `Project`
  ADD PRIMARY KEY (`ProjectID`),
  ADD KEY `Title` (`Title`),
  ADD KEY `Notes` (`Notes`(128));

--
-- Indexes for table `Skill`
--
ALTER TABLE `Skill`
  ADD PRIMARY KEY (`SkillID`),
  ADD UNIQUE KEY `Title` (`Title`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Contract`
--
ALTER TABLE `Contract`
  MODIFY `ContractID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT Contract ID PK';
--
-- AUTO_INCREMENT for table `Employee`
--
ALTER TABLE `Employee`
  MODIFY `EmployeeID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT Employee ID';
--
-- AUTO_INCREMENT for table `Equipment`
--
ALTER TABLE `Equipment`
  MODIFY `EquipmentID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT primary key';
--
-- AUTO_INCREMENT for table `Expense`
--
ALTER TABLE `Expense`
  MODIFY `ExpenseID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT primary key';
--
-- AUTO_INCREMENT for table `FileItem`
--
ALTER TABLE `FileItem`
  MODIFY `ItemID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT primary key';
--
-- AUTO_INCREMENT for table `Grade`
--
ALTER TABLE `Grade`
  MODIFY `GradeID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT ID for the grade';
--
-- AUTO_INCREMENT for table `Payslip`
--
ALTER TABLE `Payslip`
  MODIFY `PayslipID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT primary key';
--
-- AUTO_INCREMENT for table `Project`
--
ALTER TABLE `Project`
  MODIFY `ProjectID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT Project ID';
--
-- AUTO_INCREMENT for table `Skill`
--
ALTER TABLE `Skill`
  MODIFY `SkillID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'AUTO_INCREMENT Skill ID';
--
-- Constraints for dumped tables
--

--
-- Constraints for table `Assignment`
--
ALTER TABLE `Assignment`
  ADD CONSTRAINT `Assignment_ibfk_1` FOREIGN KEY (`ProjectID`) REFERENCES `Project` (`ProjectID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Assignment_ibfk_2` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Contract`
--
ALTER TABLE `Contract`
  ADD CONSTRAINT `Contract_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Employee`
--
ALTER TABLE `Employee`
  ADD CONSTRAINT `Employee_ibfk_1` FOREIGN KEY (`GradeID`) REFERENCES `Grade` (`GradeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `EmployeeSkill`
--
ALTER TABLE `EmployeeSkill`
  ADD CONSTRAINT `EmployeeSkill_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `EmployeeSkill_ibfk_2` FOREIGN KEY (`SkillID`) REFERENCES `Skill` (`SkillID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `EquipmentLoan`
--
ALTER TABLE `EquipmentLoan`
  ADD CONSTRAINT `EquipmentLoan_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `EquipmentLoan_ibfk_2` FOREIGN KEY (`EquipmentID`) REFERENCES `Equipment` (`EquipmentID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Expense`
--
ALTER TABLE `Expense`
  ADD CONSTRAINT `Expense_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Expense_ibfk_2` FOREIGN KEY (`ProjectID`) REFERENCES `Project` (`ProjectID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `FileItem`
--
ALTER TABLE `FileItem`
  ADD CONSTRAINT `FileItem_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Payslip`
--
ALTER TABLE `Payslip`
  ADD CONSTRAINT `Payslip_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
