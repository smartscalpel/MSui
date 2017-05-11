--
-- Файл сгенерирован с помощью SQLiteStudio v3.0.7 в Wed Sep 14 11:38:32 2016
--
-- Использованная кодировка текста: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Таблица: Device
CREATE TABLE Device ( ID INTEGER NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL UNIQUE, Location varchar(4000) NOT NULL, Description varchar(4000) NOT NULL)

-- Таблица: Solvent
CREATE TABLE Solvent ( ID INTEGER NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL UNIQUE, Composition varchar(4000) NOT NULL UNIQUE)

-- Таблица: Comment
CREATE TABLE Comment ( ID INTEGER NOT NULL PRIMARY KEY, "Date" timestamp NOT NULL, Comment varchar(4096) NOT NULL)

-- Таблица: TissueType
CREATE TABLE TissueType ( ID INTEGER NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL UNIQUE, Description varchar(4096))

-- Таблица: Patient
CREATE TABLE Patient ( ID INTEGER NOT NULL PRIMARY KEY, EMSID varchar(255) NOT NULL, Age integer(10) NOT NULL CHECK(Age > 0 AND Age < 120), YOB integer(10) NOT NULL CHECK (YOB > 1900 AND YOB < 2100), Sex char(1) CHECK(Sex = 'M' OR Sex='F'))

-- Таблица: Diagnosis
CREATE TABLE Diagnosis ( ID INTEGER NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL UNIQUE, Description varchar(4000), Ref varchar(1000))

-- Таблица: Tissue
CREATE TABLE Tissue ( ID integer(10) NOT NULL, PatientID integer(10) NOT NULL, Location varchar(4000) NOT NULL, Diagnosis integer(10) NOT NULL, Grade integer(10), "Date" date NOT NULL, Coords varchar(255), PRIMARY KEY (ID, PatientID), FOREIGN KEY(Diagnosis) REFERENCES Diagnosis(ID), FOREIGN KEY(PatientID) REFERENCES Patient(ID))

-- Таблица: Sample
CREATE TABLE Sample ( TumorID integer(10) NOT NULL, TumorPatientID integer(10) NOT NULL, ID integer(10) NOT NULL, Label varchar(255) NOT NULL, Coords varchar(255), Histology varchar(4000), PRIMARY KEY (TumorID, TumorPatientID, ID), FOREIGN KEY(TumorID, TumorPatientID) REFERENCES Tissue(ID, PatientID))

-- Таблица: Spectrum
CREATE TABLE Spectrum ( SampleTumorID integer(10) NOT NULL, SampleTumorPatientID integer(10) NOT NULL, SampleID integer(10) NOT NULL, ID integer(10) NOT NULL, Solvent integer(10) NOT NULL, Device integer(10) NOT NULL, RTrange integer(10), MZrange integer(10), "Date" date NOT NULL, FileName varchar(255) NOT NULL UNIQUE, PRIMARY KEY (SampleTumorID, SampleTumorPatientID, SampleID, ID), FOREIGN KEY(Solvent) REFERENCES Solvent(ID), FOREIGN KEY(Device) REFERENCES Device(ID), FOREIGN KEY(SampleTumorID, SampleTumorPatientID, SampleID) REFERENCES Sample(TumorID, TumorPatientID, ID))

-- Таблица: Sample_Comment
CREATE TABLE Sample_Comment ( SampleTumorID integer(10) NOT NULL, SampleTumorPatientID integer(10) NOT NULL, SampleID integer(10) NOT NULL, CommentID integer(10) NOT NULL, PRIMARY KEY (SampleTumorID, SampleTumorPatientID, SampleID, CommentID), FOREIGN KEY(CommentID) REFERENCES Comment(ID), FOREIGN KEY(SampleTumorID, SampleTumorPatientID, SampleID) REFERENCES Sample(TumorID, TumorPatientID, ID))

-- Таблица: Tissue_TissueType
CREATE TABLE Tissue_TissueType ( TissueID integer(10) NOT NULL, TissuePatientID integer(10) NOT NULL, TissueTypeID integer(10) NOT NULL, PRIMARY KEY (TissueID, TissuePatientID, TissueTypeID), FOREIGN KEY(TissueTypeID) REFERENCES TissueType(ID), FOREIGN KEY(TissueID, TissuePatientID) REFERENCES Tissue(ID, PatientID))

-- Таблица: Tissue_Comment
CREATE TABLE Tissue_Comment ( TissueID integer(10) NOT NULL, TissuePatientID integer(10) NOT NULL, CommentID integer(10) NOT NULL, PRIMARY KEY (TissueID, TissuePatientID, CommentID), FOREIGN KEY(CommentID) REFERENCES Comment(ID), FOREIGN KEY(TissueID, TissuePatientID) REFERENCES Tissue(ID, PatientID))

-- Таблица: Spectrum_Comment
CREATE TABLE Spectrum_Comment ( SpectrumSampleTumorID integer(10) NOT NULL, SpectrumSampleTumorPatientID integer(10) NOT NULL, SpectrumSampleID integer(10) NOT NULL, SpectrumID integer(10) NOT NULL, CommentID integer(10) NOT NULL, PRIMARY KEY (SpectrumSampleTumorID, SpectrumSampleTumorPatientID, SpectrumSampleID, SpectrumID, CommentID), FOREIGN KEY(CommentID) REFERENCES Comment(ID), FOREIGN KEY(SpectrumSampleTumorID, SpectrumSampleTumorPatientID, SpectrumSampleID, SpectrumID) REFERENCES Spectrum(SampleTumorID, SampleTumorPatientID, SampleID, ID))

-- Таблица: Diagnosis_Comment
CREATE TABLE Diagnosis_Comment ( DiagnosisID integer(10) NOT NULL, CommentID integer(10) NOT NULL, PRIMARY KEY (DiagnosisID, CommentID), FOREIGN KEY(CommentID) REFERENCES Comment(ID), FOREIGN KEY(DiagnosisID) REFERENCES Diagnosis(ID))

-- Индекс: Patient_YOB
CREATE INDEX Patient_YOB ON Patient (YOB)

-- Индекс: Patient_EMSID
CREATE UNIQUE INDEX Patient_EMSID ON Patient (EMSID)

-- Индекс: Spectrum_Date
CREATE INDEX Spectrum_Date ON Spectrum ("Date")

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
