USE DATABASE DBTHOUSE;
USE SCHEMA vkg;

CREATE TABLE State
(
	State_Code           char(2)  NOT NULL ,
	State_Name           varchar(100)  NULL ,
	 PRIMARY KEY (State_Code)
);


CREATE TABLE Location_Address
(
	Location_Address_Identifier int  NOT NULL ,
	Line_1_Address       varchar(200)  NULL ,
	Municipality_Name    varchar(100)  NULL ,
	Line_2_Address       varchar(200)  NULL ,
	Postal_Code          varchar(20)  NULL ,
	Country_Code         char(3)  NULL ,
	State_Code           char(2)  NULL ,
	Begin_Date           datetime  NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Location_Address_Identifier),
	 FOREIGN KEY (State_Code) REFERENCES State(State_Code)
);


CREATE TABLE Physical_Location
(
	Physical_Location_Identifier int  NOT NULL ,
	Physical_Location_Name varchar(100)  NULL ,
	Latitude_Value       varchar(20)  NULL ,
	Longitude_Value      varchar(20)  NULL ,
	Altitude_Value       varchar(100)  NULL ,
	Altitude_Mean_Sea_Level_Value varchar(100)  NULL ,
	Horizontal_Accuracy_Value varchar(100)  NULL ,
	Vertical_Accuracy_Value varchar(100)  NULL ,
	Travel_Direction_Description varchar(2000)  NULL ,
	Location_Address_Identifier int  NULL ,
	 PRIMARY KEY (Physical_Location_Identifier),
	 FOREIGN KEY (Location_Address_Identifier) REFERENCES Location_Address(Location_Address_Identifier)
);


CREATE TABLE Geographic_Location
(
	Geographic_Location_Identifier int  NOT NULL ,
	Parent_Geographic_Location_Identifier int  NULL ,
	Geographic_Location_Type_Code varchar(20)  NULL ,
	Location_Code        varchar(20)  NULL ,
	Location_Name        varchar(100)  NULL ,
	Location_Number      varchar(100)  NULL ,
	State_Code           char(2)  NULL ,
	Location_Address_Identifier int  NULL ,
	Physical_Location_Identifier int  NULL ,
	 PRIMARY KEY (Geographic_Location_Identifier),
	 FOREIGN KEY (Parent_Geographic_Location_Identifier) REFERENCES Geographic_Location(Geographic_Location_Identifier),
 FOREIGN KEY (State_Code) REFERENCES State(State_Code),
 FOREIGN KEY (Location_Address_Identifier) REFERENCES Location_Address(Location_Address_Identifier),
 FOREIGN KEY (Physical_Location_Identifier) REFERENCES Physical_Location(Physical_Location_Identifier)
);

CREATE TABLE Insurable_Object
(
	Insurable_Object_Identifier int  NOT NULL ,
	Geographic_Location_Identifier int  NULL ,
	Insurable_Object_Type_Code varchar(20)  NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier),
	 FOREIGN KEY (Geographic_Location_Identifier) REFERENCES Geographic_Location(Geographic_Location_Identifier)
);


CREATE TABLE Vehicle
(
	Insurable_Object_Identifier int  NOT NULL ,
	Vehicle_Model_Year   numeric(4)  NULL ,
	Vehicle_Model_Name   varchar(40)  NULL ,
	Vehicle_Driving_Wheel_Quantity int  NULL ,
	Vehicle_Make_Name    varchar(40)  NULL ,
	Vehicle_Identification_Number varchar(100)  NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier)
);

CREATE TABLE Automobile
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);



CREATE TABLE Line_Of_Business_Group
(
	Line_Of_Business_Group_Identifier int  NOT NULL ,
	Line_Of_Business_Group_Name varchar(100)  NULL ,
	Line_Of_Business_Group_Description varchar(2000)  NULL ,
	 PRIMARY KEY (Line_Of_Business_Group_Identifier)
);


CREATE TABLE Insurance_Class
(
	Insurance_Class_Identifier int  NOT NULL ,
	Insurance_Class_Name varchar(100)  NULL ,
	Insurance_Class_Description varchar(2000)  NULL ,
	 PRIMARY KEY (Insurance_Class_Identifier)
);


CREATE TABLE Line_Of_Business
(
	Line_Of_Business_Identifier int  NOT NULL ,
	Line_Of_Business_Name varchar(100)  NULL ,
	Line_Of_Business_Description varchar(2000)  NULL ,
	Line_Of_Business_Code varchar(20)  NULL ,
	Line_Of_Business_Group_Identifier int  NOT NULL ,
	Insurance_Class_Identifier int  NOT NULL ,
	 PRIMARY KEY (Line_Of_Business_Identifier),
	 FOREIGN KEY (Insurance_Class_Identifier) REFERENCES Insurance_Class(Insurance_Class_Identifier),
 FOREIGN KEY (Line_Of_Business_Group_Identifier) REFERENCES Line_Of_Business_Group(Line_Of_Business_Group_Identifier)
);


CREATE TABLE Product
(
	Product_Identifier   int  NOT NULL ,
	Line_Of_Business_Identifier int  NOT NULL ,
	Licensed_Product_Name varchar(100)  NULL ,
	Product_Description  varchar(2000)  NULL ,
	 PRIMARY KEY (Product_Identifier),
	 FOREIGN KEY (Line_Of_Business_Identifier) REFERENCES Line_Of_Business(Line_Of_Business_Identifier)
);


CREATE TABLE Agreement
(
	Agreement_Identifier int  NOT NULL ,
	Agreement_Name       varchar(100)  NULL ,
	Agreement_Original_Inception_Date datetime  NULL ,
	Product_Identifier   int  NULL ,
	Agreement_Type_Code  varchar(5)  NULL ,
	 PRIMARY KEY (Agreement_Identifier),
	 FOREIGN KEY (Product_Identifier) REFERENCES Product(Product_Identifier)
);


CREATE TABLE Auto_Repair_Shop_Contract
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Assessment
(
	Assessment_Identifier int  NOT NULL ,
	Begin_Date           datetime  NULL ,
	Assessment_Description varchar(5000)  NULL ,
	End_Date             datetime  NULL ,
	Assessment_Reason_Description varchar(2000)  NULL ,
	 PRIMARY KEY (Assessment_Identifier )
);


CREATE TABLE Assessment_Result
(
	Assessment_Result_Identifier int  NOT NULL ,
	Assessment_Identifier int  NULL ,
	Assessment_Result_Type_Code varchar(20)  NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier),
	 FOREIGN KEY (Assessment_Identifier) REFERENCES Assessment(Assessment_Identifier)
);


CREATE TABLE Approval
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Event
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier)
);


CREATE TABLE Policy
(
	Policy_Identifier    int  NOT NULL ,
	Effective_Date       datetime  NULL ,
	Expiration_Date      datetime  NULL ,
	Policy_Number        varchar(50)  NULL ,
	Status_Code          varchar(20)  NULL ,
	Geographic_Location_Identifier int  NULL ,
	 PRIMARY KEY (Policy_Identifier),
	 FOREIGN KEY (Geographic_Location_Identifier) REFERENCES Geographic_Location(Geographic_Location_Identifier),
 FOREIGN KEY (Policy_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Policy_Event
(
	Event_Identifier     int  NOT NULL ,
	Event_Date           datetime  NULL ,
	Effective_Date       datetime  NULL ,
	Event_Type_Code      varchar(20)  NULL ,
	Event_Sub_Type_Code  varchar(20)  NULL ,
	Policy_Identifier    int  NULL ,
	 PRIMARY KEY (Event_Identifier),
	 FOREIGN KEY (Event_Identifier) REFERENCES Event(Event_Identifier),
 FOREIGN KEY (Policy_Identifier) REFERENCES Policy(Policy_Identifier)
);


CREATE TABLE Endorsement
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier),
	 FOREIGN KEY (Event_Identifier) REFERENCES Policy_Event(Event_Identifier)
);


CREATE TABLE Audit
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier),
	 FOREIGN KEY (Event_Identifier) REFERENCES Endorsement(Event_Identifier)
);


CREATE TABLE Coverage_Type
(
	Coverage_Type_Identifier int  NOT NULL ,
	Coverage_Type_Description varchar(2000)  NULL ,
	Coverage_Type_Name   varchar(100)  NULL ,
	 PRIMARY KEY (Coverage_Type_Identifier)
);


CREATE TABLE Coverage_Group
(
	Coverage_Group_Identifier int  NOT NULL ,
	Coverage_Group_Description varchar(2000)  NULL ,
	Coverage_Group_Name  varchar(100)  NULL ,
	 PRIMARY KEY (Coverage_Group_Identifier)
);


CREATE TABLE Coverage_Part
(
	Coverage_Part_Code   varchar(20)  NOT NULL ,
	Coverage_Part_Name   varchar(100)  NULL ,
	 PRIMARY KEY (Coverage_Part_Code)
);


CREATE TABLE Coverage
(
	Coverage_Identifier  int  NOT NULL ,
	Coverage_Description varchar(5000)  NULL ,
	Coverage_Name        varchar(200)  NULL ,
	Coverage_Type_Identifier int  NULL ,
	Coverage_Group_Identifier int  NULL ,
	Coverage_Part_Code   varchar(20)  NULL ,
	 PRIMARY KEY (Coverage_Identifier),
	 FOREIGN KEY (Coverage_Type_Identifier) REFERENCES Coverage_Type(Coverage_Type_Identifier),
 FOREIGN KEY (Coverage_Group_Identifier) REFERENCES Coverage_Group(Coverage_Group_Identifier),
 FOREIGN KEY (Coverage_Part_Code) REFERENCES Coverage_Part(Coverage_Part_Code)
);


CREATE TABLE Policy_Coverage_Part
(
	Coverage_Part_Code   varchar(20)  NOT NULL ,
	Policy_Identifier    int  NOT NULL ,
	 PRIMARY KEY (Coverage_Part_Code, Policy_Identifier),
	 FOREIGN KEY (Policy_Identifier) REFERENCES Policy(Policy_Identifier),
 FOREIGN KEY (Coverage_Part_Code) REFERENCES Coverage_Part(Coverage_Part_Code)
);


CREATE TABLE Policy_Coverage_Detail
(
	Effective_Date       datetime  NOT NULL ,
	Policy_Coverage_Detail_Identifier int  NOT NULL ,
	Coverage_Identifier  int  NOT NULL ,
	Insurable_Object_Identifier int  NOT NULL ,
	Policy_Identifier    int  NOT NULL ,
	Coverage_Part_Code   varchar(20)  NOT NULL ,
	Coverage_Description varchar(2000)  NULL ,
	Expiration_Date      datetime  NULL ,
	Coverage_Inclusion_Exclusion_Code char(1)  NULL ,
	 PRIMARY KEY (Effective_Date,Policy_Coverage_Detail_Identifier),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier),
 FOREIGN KEY (Coverage_Identifier) REFERENCES Coverage(Coverage_Identifier),
 FOREIGN KEY (Coverage_Part_Code,Policy_Identifier) REFERENCES Policy_Coverage_Part(Coverage_Part_Code,Policy_Identifier)
);


CREATE TABLE Policy_Amount
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	Geographic_Location_Identifier int  NOT NULL ,
	Policy_Identifier    int  NULL ,
	Effective_Date       datetime  NULL ,
	Amount_Type_Code     varchar(5)  NULL ,
	Earning_Begin_Date   datetime  NULL ,
	Earning_End_Date     datetime  NULL ,
	Policy_Coverage_Detail_Identifier int  NULL ,
	Policy_Amount        decimal(15,2)  NULL ,
	Insurable_Object_Identifier int  NULL ,
	Insurance_Type_Code  char(1)  NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier),
	 FOREIGN KEY (Effective_Date,Policy_Coverage_Detail_Identifier) REFERENCES Policy_Coverage_Detail(Effective_Date,Policy_Coverage_Detail_Identifier),
 FOREIGN KEY (Policy_Identifier) REFERENCES Policy(Policy_Identifier),
 FOREIGN KEY (Geographic_Location_Identifier) REFERENCES Geographic_Location(Geographic_Location_Identifier),
 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier)
);


CREATE TABLE Assumed_Policy_Amount
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);


CREATE TABLE Party
(
	Party_Identifier     bigint  NOT NULL ,
	Party_Name           varchar(100)  NULL ,
	Begin_Date           datetime  NULL ,
	End_Date             datetime  NULL ,
	Party_Type_Code      char(1)  NULL ,
	 PRIMARY KEY (Party_Identifier)
);


CREATE TABLE Organization
(
	Organization_Identifier bigint  NOT NULL ,
	Industry_Code        varchar(20)  NULL ,
	Organization_Name    varchar(100)  NULL ,
	Dun_And_Bradstreet_Identifier int  NULL ,
	Organization_Type_Code varchar(20)  NULL ,
	Alternate_Name       varchar(200)  NULL ,
	Organization_Description varchar(5000)  NULL ,
	Acronym_Name         varchar(40)  NULL ,
	Industry_Type_Code   varchar(5)  NULL ,
	 PRIMARY KEY (Organization_Identifier),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Party(Party_Identifier)
);


CREATE TABLE For_Profit_Organization
(
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Organization_Identifier),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Organization(Organization_Identifier)
);


CREATE TABLE Cancel
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier),
	 FOREIGN KEY (Event_Identifier) REFERENCES Policy_Event(Event_Identifier)
);


CREATE TABLE Flat
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier),
	 FOREIGN KEY (Event_Identifier) REFERENCES Cancel(Event_Identifier)
);


CREATE TABLE Direct_Policy_Amount
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);


CREATE TABLE Body_Object
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier)
);



CREATE TABLE Animal
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Body_Object(Insurable_Object_Identifier)
);


CREATE TABLE Party_Role
(
	Party_Role_Code      varchar(20)  NOT NULL ,
	Party_Role_Name      varchar(100)  NULL ,
	Party_Role_Description varchar(2000)  NULL ,
	 PRIMARY KEY (Party_Role_Code)
);

CREATE TABLE Agreement_Party_Role
(
	Agreement_Identifier int  NOT NULL ,
	Party_Identifier     bigint  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Effective_Date       datetime  NOT NULL ,
	Expiration_Date      datetime  NULL ,
	 PRIMARY KEY (Agreement_Identifier ,Party_Identifier ,Party_Role_Code ,Effective_Date ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier),
 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);


CREATE TABLE Agreement_Assessment
(
	Agreement_Identifier int  NOT NULL ,
	Assessment_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ,Assessment_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier),
 FOREIGN KEY (Assessment_Identifier) REFERENCES Assessment(Assessment_Identifier)
);


CREATE TABLE Account
(
	Account_Identifier   int  NOT NULL ,
	Account_Type_Code    varchar(5)  NULL ,
	Account_Name         varchar(100)  NULL ,
	 PRIMARY KEY (Account_Identifier)
);


CREATE TABLE Account_Agreement
(
	Account_Identifier   int  NOT NULL ,
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Account_Identifier ,Agreement_Identifier ),
	 FOREIGN KEY (Account_Identifier) REFERENCES Account(Account_Identifier),
 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Agency_Contract
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Financial_Services_Assessment
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);

CREATE TABLE Financial_Account_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Group_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Credit_Policy_Amount
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);


CREATE TABLE Boat
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);


CREATE TABLE Occurrence
(
	Occurrence_Identifier int  NOT NULL ,
	Catastrophic_Event_Indicator char(1)  NULL ,
	Geographic_Location_Identifier int  NULL ,
	Occurrence_Begin_Date datetime  NULL ,
	Occurrence_End_Date  datetime  NULL ,
	Occurrence_Begin_Time datetime  NULL ,
	Occurrence_End_Time  datetime  NULL ,
	Occurrence_Name      varchar(100)  NULL ,
	 PRIMARY KEY (Occurrence_Identifier),
	 FOREIGN KEY (Geographic_Location_Identifier) REFERENCES Geographic_Location(Geographic_Location_Identifier)
);

CREATE TABLE Catastrophe
(
	Catastrophe_Identifier int  NOT NULL ,
	Catastrophe_Type_Code varchar(20)  NULL ,
	Catastrophe_Name     varchar(100)  NULL ,
	Industry_Catastrophe_Code varchar(20)  NULL ,
	Company_Catastrophe_Code varchar(20)  NULL ,
	 PRIMARY KEY (Catastrophe_Identifier)
);


CREATE TABLE Claim
(
	Claim_Identifier     int  NOT NULL ,
	Catastrophe_Identifier int  NULL ,
	Claim_Description    varchar(5000)  NULL ,
	Claims_Made_Date     datetime  NULL ,
	Company_Claim_Number varchar(20)  NULL ,
	Company_Subclaim_Number varchar(5)  NULL ,
	Insurable_Object_Identifier int  NULL ,
	Occurrence_Identifier int  NULL ,
	Entry_Into_Claims_Made_Program_Date datetime  NULL ,
	Claim_Open_Date      datetime  NULL ,
	Claim_Close_Date     datetime  NULL ,
	Claim_Reopen_Date    datetime  NULL ,
	Claim_Status_Code    varchar(5)  NULL ,
	Claim_Reported_Date  datetime  NULL ,
	 PRIMARY KEY (Claim_Identifier ),
	 FOREIGN KEY (Catastrophe_Identifier) REFERENCES Catastrophe(Catastrophe_Identifier),
 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier),
 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier),
 FOREIGN KEY (Occurrence_Identifier) REFERENCES Occurrence(Occurrence_Identifier)
);

CREATE TABLE Claim_Party_Role
(
	Claim_Identifier     int  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Begin_Date           datetime  NOT NULL ,
	Party_Identifier     bigint  NOT NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Claim_Identifier ,Party_Role_Code ,Begin_Date ,Party_Identifier ),
	 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier),
 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);


CREATE TABLE Government_Organization
(
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Organization_Identifier),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Organization(Organization_Identifier)
);


CREATE TABLE Fraud_Assessment
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Claim_Folder
(
	Claim_Identifier     int  NOT NULL ,
	Claim_Folder_Label_Name varchar(100)  NULL ,
	 PRIMARY KEY (Claim_Identifier ),
	 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier)
);


CREATE TABLE Claim_Folder_Document
(
	Document_Sequence_Number smallint  NOT NULL ,
	Claim_Identifier     int  NOT NULL ,
	Document_Link_Value  varchar(1000)  NULL ,
	 PRIMARY KEY (Document_Sequence_Number ,Claim_Identifier ),
	 FOREIGN KEY (Claim_Identifier) REFERENCES Claim_Folder(Claim_Identifier)
);

CREATE TABLE Medical_Condition
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Full_Term
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Endorsement(Event_Identifier)
);


CREATE TABLE Grouping
(
	Grouping_Identifier  bigint  NOT NULL ,
	Grouping_Name        varchar(100)  NULL ,
	 PRIMARY KEY (Grouping_Identifier ),
	 FOREIGN KEY (Grouping_Identifier) REFERENCES Party(Party_Identifier)
);


CREATE TABLE Household
(
	Household_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Household_Identifier ),
	 FOREIGN KEY (Household_Identifier) REFERENCES Grouping(Grouping_Identifier)
);


CREATE TABLE Transportation_Class
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier)
);



CREATE TABLE Household_Content
(
	Insurable_Object_Identifier int  NOT NULL ,
	Household_Identifier bigint  NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Household_Identifier) REFERENCES Household(Household_Identifier),
 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Transportation_Class(Insurable_Object_Identifier)
);


CREATE TABLE Freight_Group
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Transportation_Class(Insurable_Object_Identifier)
);


CREATE TABLE Channel_Score
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Ceded_Policy_Amount
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier ),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);


CREATE TABLE Business_Event
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Event(Event_Identifier)
);


CREATE TABLE Bus
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);


CREATE TABLE Brokerage_Contract
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Organization_Unit
(
	Organization_Identifier bigint  NOT NULL ,
	Organization_Unit_Name varchar(100)  NULL ,
	Organization_Unit_Description varchar(2000)  NULL ,
	Industry_Code        varchar(20)  NULL ,
	Accounting_Code      varchar(20)  NULL ,
	Work_Site_Type_Code  varchar(20)  NULL ,
	 PRIMARY KEY (Organization_Identifier),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Organization(Organization_Identifier)
);


CREATE TABLE Field_Organization_Unit
(
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Organization_Identifier ),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Organization_Unit(Organization_Identifier)
);



CREATE TABLE Territory
(
	Territory_Identifier bigint  NOT NULL ,
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Territory_Identifier ,Organization_Identifier ),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Field_Organization_Unit(Organization_Identifier)
);


CREATE TABLE Regional_Office
(
	Regional_Office_Identifier bigint  NOT NULL ,
	Territory_Identifier bigint  NOT NULL ,
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Regional_Office_Identifier ,Territory_Identifier ,Organization_Identifier ),
	 FOREIGN KEY (Territory_Identifier,Organization_Identifier) REFERENCES Territory(Territory_Identifier,Organization_Identifier)
);


CREATE TABLE Branch_Office
(
	Branch_Office_Identifier bigint  NOT NULL ,
	Regional_Office_Identifier bigint  NOT NULL ,
	Territory_Identifier bigint  NOT NULL ,
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Branch_Office_Identifier ,Regional_Office_Identifier ,Territory_Identifier ,Organization_Identifier ),
	 FOREIGN KEY (Regional_Office_Identifier,Territory_Identifier,Organization_Identifier) REFERENCES Regional_Office(Regional_Office_Identifier,Territory_Identifier,Organization_Identifier)
);


CREATE TABLE Policy_Form
(
	Policy_Form_Number   varchar(50)  NOT NULL ,
	Policy_Identifier    int  NOT NULL ,
	Form_Value           varchar(50)  NULL ,
	 PRIMARY KEY (Policy_Form_Number ,Policy_Identifier ),
	 FOREIGN KEY (Policy_Identifier) REFERENCES Policy(Policy_Identifier)
);


CREATE TABLE Mid_Term
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Endorsement(Event_Identifier)
);


CREATE TABLE Intermediary_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Coverage_Limit_Type
(
	Coverage_Limit_Type_Identifier int  NOT NULL ,
	Coverage_Limit_Name  varchar(100)  NULL ,
	Coverage_Limit_Description varchar(2000)  NULL ,
	 PRIMARY KEY (Coverage_Limit_Type_Identifier )
);


CREATE TABLE Coverage_Level
(
	Coverage_Level_Identifier int  NOT NULL ,
	Coverage_Limit_Type_Identifier int  NOT NULL ,
	Coverage_Identifier  int  NOT NULL ,
	Maximum_Per_Person_Amount decimal(15,2)  NULL ,
	Aggregate_Limit_Amount decimal(15,2)  NULL ,
	Maximum_Per_Claim_Amount decimal(15,2)  NULL ,
	Deductible_Rate      decimal(5,5)  NULL ,
	Coverage_Label_Name  varchar(200)  NULL ,
	 PRIMARY KEY (Coverage_Level_Identifier ,Coverage_Limit_Type_Identifier ,Coverage_Identifier ),
	 FOREIGN KEY (Coverage_Identifier) REFERENCES Coverage(Coverage_Identifier),
 FOREIGN KEY (Coverage_Limit_Type_Identifier) REFERENCES Coverage_Limit_Type(Coverage_Limit_Type_Identifier)
);


CREATE TABLE Structure
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier)
);


CREATE TABLE Residential_Structure
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Structure(Insurable_Object_Identifier)
);


CREATE TABLE Mobile_Home
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Residential_Structure(Insurable_Object_Identifier)
);


CREATE TABLE Insured_Account
(
	Account_Identifier   int  NOT NULL ,
	 PRIMARY KEY (Account_Identifier ),
	 FOREIGN KEY (Account_Identifier) REFERENCES Account(Account_Identifier)
);


CREATE TABLE Farm_Equipment
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier)
);


CREATE TABLE Milking_Machine
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Farm_Equipment(Insurable_Object_Identifier)
);


CREATE TABLE Individual_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);

CREATE TABLE Party_Preference
(
	Party_Identifier     bigint  NOT NULL ,
	Preferred_Language_Code varchar(20)  NULL ,
	 PRIMARY KEY (Party_Identifier ),
	 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier)
);



CREATE TABLE Construction_Vehicle
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);


CREATE TABLE Claim_Coverage
(
	Claim_Identifier     int  NOT NULL ,
	Effective_Date       datetime  NOT NULL ,
	Policy_Coverage_Detail_Identifier int  NOT NULL ,
	 PRIMARY KEY (Claim_Identifier ,Effective_Date ,Policy_Coverage_Detail_Identifier ),
	 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier),
 FOREIGN KEY (Effective_Date,Policy_Coverage_Detail_Identifier) REFERENCES Policy_Coverage_Detail(Effective_Date,Policy_Coverage_Detail_Identifier)
);

CREATE TABLE Person
(
	Person_Identifier    bigint  NOT NULL ,
	First_Name           varchar(40)  NULL ,
	Middle_Name          varchar(40)  NULL ,
	Last_Name            varchar(40)  NULL ,
	Full_Legal_Name      varchar(100)  NULL ,
	Nickname             varchar(40)  NULL ,
	Suffix_Name          varchar(20)  NULL ,
	Birth_Date           datetime  NULL ,
	Birth_Place_Name     varchar(100)  NULL ,
	Gender_Code          char(1)  NULL ,
	Prefix_Name          varchar(20)  NULL ,
	 PRIMARY KEY (Person_Identifier ),
	 FOREIGN KEY (Person_Identifier) REFERENCES Party(Party_Identifier)
);



CREATE TABLE Household_Person
(
	Household_Identifier bigint  NOT NULL ,
	Person_Identifier    bigint  NOT NULL ,
	 PRIMARY KEY (Household_Identifier ,Person_Identifier ),
	 FOREIGN KEY (Household_Identifier) REFERENCES Household(Household_Identifier),
 FOREIGN KEY (Person_Identifier) REFERENCES Person(Person_Identifier)
);


CREATE TABLE Household_Person_Role
(
	Household_Identifier bigint  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Begin_Date           datetime  NOT NULL ,
	Person_Identifier    bigint  NOT NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Household_Identifier ,Party_Role_Code ,Begin_Date ,Person_Identifier ),
	 FOREIGN KEY (Household_Identifier,Person_Identifier) REFERENCES Household_Person(Household_Identifier,Person_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);

CREATE TABLE Commutation_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Commercial_Structure
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Structure(Insurable_Object_Identifier)
);

CREATE TABLE Commercial_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Combine
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Farm_Equipment(Insurable_Object_Identifier)
);


CREATE TABLE Combination_Structure
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Structure(Insurable_Object_Identifier)
);


CREATE TABLE Life_Event
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Event(Event_Identifier)
);


CREATE TABLE Fee
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier ),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);


CREATE TABLE Manufactured_Object
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier)
);


CREATE TABLE Claim_Event
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Event(Event_Identifier)
);


CREATE TABLE Staff_Classification
(
	Staff_Classification_Code varchar(20)  NOT NULL ,
	Staff_Classification_Name varchar(100)  NULL ,
	Staff_Classification_Description varchar(2000)  NULL ,
	 PRIMARY KEY (Staff_Classification_Code )
);

CREATE TABLE Staff_Position
(
	Staff_Position_Identifier int  NOT NULL ,
	Staff_Position_Name  varchar(100)  NULL ,
	Staff_Position_Description varchar(2000)  NULL ,
	Staff_Classification_Code varchar(20)  NULL ,
	 PRIMARY KEY (Staff_Position_Identifier ),
	 FOREIGN KEY (Staff_Classification_Code) REFERENCES Staff_Classification(Staff_Classification_Code)
);


CREATE TABLE Staff_Position_Assignment
(
	Begin_Date           datetime  NOT NULL ,
	Person_Identifier    bigint  NOT NULL ,
	Organization_Identifier bigint  NOT NULL ,
	Staff_Position_Identifier int  NOT NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Begin_Date ,Person_Identifier ,Organization_Identifier ,Staff_Position_Identifier ),
	 FOREIGN KEY (Person_Identifier) REFERENCES Person(Person_Identifier),
 FOREIGN KEY (Organization_Identifier) REFERENCES Organization(Organization_Identifier),
 FOREIGN KEY (Staff_Position_Identifier) REFERENCES Staff_Position(Staff_Position_Identifier)
);


CREATE TABLE Not_For_Profit_Organization
(
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Organization_Identifier ),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Organization(Organization_Identifier)
);


CREATE TABLE Motorcycle
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);


CREATE TABLE Object_Assessment
(
	Insurable_Object_Identifier int  NOT NULL ,
	Assessment_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ,Assessment_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier),
 FOREIGN KEY (Assessment_Identifier) REFERENCES Assessment(Assessment_Identifier)
);


CREATE TABLE Dwelling
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Residential_Structure(Insurable_Object_Identifier)
);


CREATE TABLE Financial_Valuation
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Derivative_Contract
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Administrative_Organization_Unit
(
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Organization_Identifier ),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Organization_Unit(Organization_Identifier)
);


CREATE TABLE Department
(
	Department_Identifier bigint  NOT NULL ,
	Organization_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Department_Identifier ,Organization_Identifier ),
	 FOREIGN KEY (Organization_Identifier) REFERENCES Administrative_Organization_Unit(Organization_Identifier)
);


CREATE TABLE Demographic_Score
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Arbitration
(
	Arbitration_Identifier int  NOT NULL ,
	Arbitration_Description varchar(5000)  NULL ,
	 PRIMARY KEY (Arbitration_Identifier )
);


CREATE TABLE Court_Jurisdiction
(
	Court_Identifier     int  NOT NULL ,
	Jurisdiction_Identifier int  NOT NULL ,
	Court_Name           varchar(100)  NULL ,
	 PRIMARY KEY (Court_Identifier ,Jurisdiction_Identifier )
);


CREATE TABLE Litigation
(
	Litigation_Identifier int  NOT NULL ,
	Court_Identifier     int  NULL ,
	Jurisdiction_Identifier int  NULL ,
	Litigation_Description varchar(5000)  NULL ,
	 PRIMARY KEY (Litigation_Identifier ),
	 FOREIGN KEY (Court_Identifier,Jurisdiction_Identifier) REFERENCES Court_Jurisdiction(Court_Identifier,Jurisdiction_Identifier)
);


CREATE TABLE Claim_Offer
(
	Claim_Offer_Identifier int  NOT NULL ,
	Claim_Identifier     int  NOT NULL ,
	Arbitration_Identifier int  NULL ,
	Litigation_Identifier int  NULL ,
	Settlement_Offer_Amount decimal(15,2)  NULL ,
	Settlement_Offer_Provision_Description varchar(5000)  NULL ,
	 PRIMARY KEY (Claim_Offer_Identifier ),
	 FOREIGN KEY (Claim_Identifier) REFERENCES Claim_Folder(Claim_Identifier),
 FOREIGN KEY (Arbitration_Identifier) REFERENCES Arbitration(Arbitration_Identifier),
 FOREIGN KEY (Litigation_Identifier) REFERENCES Litigation(Litigation_Identifier)
);


CREATE TABLE Claim_Amount
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	Claim_Identifier     int  NOT NULL ,
	Claim_Offer_Identifier int  NULL ,
	Amount_Type_Code     varchar(20)  NULL ,
	Event_Date           datetime  NULL ,
	Claim_Amount         decimal(15,2)  NULL ,
	Insurance_Type_Code  char(1)  NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Offer_Identifier) REFERENCES Claim_Offer(Claim_Offer_Identifier),
 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier)
);

CREATE TABLE Recovery
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Amount(Claim_Amount_Identifier)
);


CREATE TABLE Deductible_Recovery
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Recovery(Claim_Amount_Identifier)
);


CREATE TABLE Policy_Deductible
(
	Policy_Deductible_Identifier int  NOT NULL ,
	Effective_Date       datetime  NULL ,
	Policy_Coverage_Detail_Identifier int  NULL ,
	Deductible_Type_Code varchar(20)  NULL ,
	Deductible_Value     varchar(100)  NULL ,
	Deductible_Basis_Code varchar(20)  NULL ,
	 PRIMARY KEY (Policy_Deductible_Identifier ),
	 FOREIGN KEY (Effective_Date,Policy_Coverage_Detail_Identifier) REFERENCES Policy_Coverage_Detail(Effective_Date,Policy_Coverage_Detail_Identifier)
);


CREATE TABLE Customer_Score
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Credit_Rating
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Claim_Payment
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Amount(Claim_Amount_Identifier)
);


CREATE TABLE Loss_Payment
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Payment(Claim_Amount_Identifier)
);

CREATE TABLE Underwriting_Assessment
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Physical_Object_Assessment
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Provider_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);

CREATE TABLE Pro_Rata
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Cancel(Event_Identifier)
);


CREATE TABLE Party_Assessment
(
	Person_Identifier    bigint  NOT NULL ,
	Assessment_Identifier int  NOT NULL ,
	Party_Identifier     bigint  NOT NULL ,
	 PRIMARY KEY (Person_Identifier ,Assessment_Identifier ,Party_Identifier ),
	 FOREIGN KEY (Person_Identifier) REFERENCES Person(Person_Identifier),
 FOREIGN KEY (Assessment_Identifier) REFERENCES Assessment(Assessment_Identifier),
 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier)
);


CREATE TABLE Premium
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier ),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);

CREATE TABLE Insurable_Object_Party_Role
(
	Insurable_Object_Identifier int  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Effective_Date       datetime  NOT NULL ,
	Party_Identifier     bigint  NOT NULL ,
	Expiration_Date      datetime  NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ,Party_Role_Code ,Effective_Date ,Party_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier),
 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);

CREATE TABLE Account_Party_Role
(
	Account_Identifier   integer  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Party_Identifier     bigint  NOT NULL ,
	 PRIMARY KEY (Account_Identifier ,Party_Role_Code ,Party_Identifier ),
	 FOREIGN KEY (Account_Identifier) REFERENCES Account(Account_Identifier),
 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);

CREATE TABLE Property_In_Transit
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Transportation_Class(Insurable_Object_Identifier)
);


CREATE TABLE Other_Assessment_Result
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);


CREATE TABLE Policy_Relationship
(
	Relationship_Code    varchar(20)  NOT NULL ,
	Effective_Date       datetime  NOT NULL ,
	Policy_Identifier    int  NOT NULL ,
	Related_Policy_Identifier int  NOT NULL ,
	Expiration_Date      datetime  NULL ,
	 PRIMARY KEY (Relationship_Code ,Effective_Date ,Policy_Identifier ,Related_Policy_Identifier ),
	 FOREIGN KEY (Policy_Identifier) REFERENCES Policy(Policy_Identifier),
 FOREIGN KEY (Related_Policy_Identifier) REFERENCES Policy(Policy_Identifier)
);

CREATE TABLE Company
(
	Company_Identifier   int  NOT NULL ,
	Company_Code         varchar(5)  NULL ,
	Company_Description  varchar(2000)  NULL ,
	Company_Name         varchar(100)  NULL ,
	 PRIMARY KEY (Company_Identifier )
);

CREATE TABLE Company_Jurisdiction
(
	Company_Identifier   int  NOT NULL ,
	Geographic_Location_Identifier int  NOT NULL ,
	 PRIMARY KEY (Company_Identifier ,Geographic_Location_Identifier ),
	 FOREIGN KEY (Company_Identifier) REFERENCES Company(Company_Identifier),
 FOREIGN KEY (Geographic_Location_Identifier) REFERENCES Geographic_Location(Geographic_Location_Identifier)
);


CREATE TABLE Product_License
(
	Company_Identifier   int  NOT NULL ,
	Product_Identifier   int  NOT NULL ,
	Geographic_Location_Identifier int  NOT NULL ,
	Effective_Date       datetime  NULL ,
	Expiration_Date      datetime  NULL ,
	 PRIMARY KEY (Company_Identifier ,Product_Identifier ,Geographic_Location_Identifier ),
	 FOREIGN KEY (Company_Identifier,Geographic_Location_Identifier) REFERENCES Company_Jurisdiction(Company_Identifier,Geographic_Location_Identifier),
 FOREIGN KEY (Product_Identifier) REFERENCES Product(Product_Identifier)
);


CREATE TABLE Product_Coverage
(
	Product_Identifier   int  NOT NULL ,
	Coverage_Identifier  int  NOT NULL ,
	 PRIMARY KEY (Product_Identifier ,Coverage_Identifier ),
	 FOREIGN KEY (Coverage_Identifier) REFERENCES Coverage(Coverage_Identifier),
 FOREIGN KEY (Product_Identifier) REFERENCES Product(Product_Identifier)
);


CREATE TABLE Claim_Evaluation_Result
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);

CREATE TABLE Trailer
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);


CREATE TABLE Recreational_Vehicle
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);


CREATE TABLE Salvage
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Recovery(Claim_Amount_Identifier)
);


CREATE TABLE Reinsurance_Recovery
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Recovery(Claim_Amount_Identifier)
);


CREATE TABLE Staffing_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);


CREATE TABLE Consultant_Contract
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Staffing_Agreement(Agreement_Identifier)
);


CREATE TABLE New_Business
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Policy_Event(Event_Identifier)
);


CREATE TABLE Risk_Factor_Score
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);

CREATE TABLE Scheduled_Item
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Transportation_Class(Insurable_Object_Identifier)
);


CREATE TABLE Employment_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Staffing_Agreement(Agreement_Identifier)
);


CREATE TABLE Short_Rate
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Cancel(Event_Identifier)
);


CREATE TABLE Quote
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Policy_Event(Event_Identifier)
);

CREATE TABLE Subrogation
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Recovery(Claim_Amount_Identifier)
);


CREATE TABLE Surcharge
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier ),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);


CREATE TABLE Tax
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier ),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);


CREATE TABLE Third_Party_Staffing_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Staffing_Agreement(Agreement_Identifier)
);


CREATE TABLE Reinstatement
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Policy_Event(Event_Identifier)
);


CREATE TABLE Tractor
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Farm_Equipment(Insurable_Object_Identifier)
);


CREATE TABLE Place_Assessment
(
	Assessment_Result_Identifier int  NOT NULL ,
	 PRIMARY KEY (Assessment_Result_Identifier ),
	 FOREIGN KEY (Assessment_Result_Identifier) REFERENCES Assessment_Result(Assessment_Result_Identifier)
);

CREATE TABLE Arbitration_Party_Role
(
	Arbitration_Identifier int  NOT NULL ,
	Party_Identifier     bigint  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Begin_Date           datetime  NOT NULL ,
	Claim_Identifier     int  NOT NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Arbitration_Identifier ,Party_Identifier ,Party_Role_Code ,Begin_Date ,Claim_Identifier ),
	 FOREIGN KEY (Arbitration_Identifier) REFERENCES Arbitration(Arbitration_Identifier),
 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);


CREATE TABLE Communication_Identity
(
	Communication_Identifier int  NOT NULL ,
	Communication_Type_Code varchar(20)  NULL ,
	Communication_Value  varchar(1000)  NULL ,
	Communication_Qualifier_Value varchar(1000)  NULL ,
	Geographic_Location_Identifier int  NULL ,
	 PRIMARY KEY (Communication_Identifier ),
	 FOREIGN KEY (Geographic_Location_Identifier) REFERENCES Geographic_Location(Geographic_Location_Identifier)
);



CREATE TABLE Party_Communication
(
	Begin_Date           datetime  NOT NULL ,
	Party_Identifier     bigint  NOT NULL ,
	Communication_Identifier int  NOT NULL ,
	Party_Locality_Code  varchar(20)  NOT NULL ,
	End_Date             datetime  NULL ,
	Preference_Sequence_Number smallint  NULL ,
	Preference_Day_And_Time_Group_Code varchar(20)  NULL ,
	Party_Routing_Description varchar(2000)  NULL ,
	 PRIMARY KEY (Begin_Date ,Party_Identifier ,Communication_Identifier ,Party_Locality_Code ),
	 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Communication_Identifier) REFERENCES Communication_Identity(Communication_Identifier)
);


CREATE TABLE Truck
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);


CREATE TABLE Person_Profession
(
	Person_Identifier    bigint  NOT NULL ,
	Profession_Name      varchar(100)  NULL ,
	 PRIMARY KEY (Person_Identifier ),
	 FOREIGN KEY (Person_Identifier) REFERENCES Person(Person_Identifier)
);

CREATE TABLE Van
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);

CREATE TABLE Professional_Group
(
	Grouping_Identifier  bigint  NOT NULL ,
	 PRIMARY KEY (Grouping_Identifier ),
	 FOREIGN KEY (Grouping_Identifier) REFERENCES Grouping(Grouping_Identifier)
);


CREATE TABLE Watercraft
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Vehicle(Insurable_Object_Identifier)
);


CREATE TABLE Party_Relationship
(
	Party_Identifier     bigint  NOT NULL ,
	Related_Party_Identifier bigint  NOT NULL ,
	Relationship_Type_Code varchar(20)  NOT NULL ,
	Begin_Date           datetime  NOT NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Party_Identifier ,Related_Party_Identifier ,Relationship_Type_Code ,Begin_Date ),
	 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Related_Party_Identifier) REFERENCES Party(Party_Identifier)
);


CREATE TABLE Party_Relationship_Role
(
	Party_Identifier     bigint  NOT NULL ,
	Related_Party_Identifier bigint  NOT NULL ,
	Relationship_Type_Code varchar(20)  NOT NULL ,
	Relationship_Begin_Date datetime  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Role_Begin_Date      datetime  NOT NULL ,
	 PRIMARY KEY (Party_Identifier ,Related_Party_Identifier ,Relationship_Type_Code ,Relationship_Begin_Date ,Party_Role_Code ,Role_Begin_Date ),
	 FOREIGN KEY (Party_Identifier,Related_Party_Identifier,Relationship_Type_Code,Relationship_Begin_Date) REFERENCES Party_Relationship(Party_Identifier,Related_Party_Identifier,Relationship_Type_Code,Begin_Date),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);


CREATE TABLE Rating_Territory
(
	Rating_Territory_Identifier int  NOT NULL ,
	Rating_Territory_Assigning_Organization_Identifier bigint  NOT NULL ,
	Rating_Territory_Code varchar(20)  NULL ,
	Rating_Territory_Code_Set_Identifier int  NULL ,
	 PRIMARY KEY (Rating_Territory_Identifier )
);

CREATE TABLE Rating_Territory_Geographic_Location
(
	Geographic_Location_Identifier int  NOT NULL ,
	Rating_Territory_Identifier int  NOT NULL ,
	 PRIMARY KEY (Geographic_Location_Identifier ,Rating_Territory_Identifier ),
	 FOREIGN KEY (Geographic_Location_Identifier) REFERENCES Geographic_Location(Geographic_Location_Identifier),
 FOREIGN KEY (Rating_Territory_Identifier) REFERENCES Rating_Territory(Rating_Territory_Identifier)
);


CREATE TABLE Claim_Arbitration
(
	Claim_Identifier     int  NOT NULL ,
	Arbitration_Identifier int  NOT NULL ,
	 PRIMARY KEY (Claim_Identifier ,Arbitration_Identifier ),
	 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier),
 FOREIGN KEY (Arbitration_Identifier) REFERENCES Arbitration(Arbitration_Identifier)
);


CREATE TABLE Binding
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Policy_Event(Event_Identifier)
);

CREATE TABLE Policy_Limit
(
	Policy_Limit_Identifier int  NOT NULL ,
	Effective_Date       datetime  NULL ,
	Policy_Coverage_Detail_Identifier int  NULL ,
	Limit_Type_Code      varchar(20)  NULL ,
	Limit_Value          varchar(100)  NULL ,
	Limit_Basis_Code     varchar(20)  NULL ,
	 PRIMARY KEY (Policy_Limit_Identifier ),
	 FOREIGN KEY (Effective_Date,Policy_Coverage_Detail_Identifier) REFERENCES Policy_Coverage_Detail(Effective_Date,Policy_Coverage_Detail_Identifier)
);


CREATE TABLE Team
(
	Grouping_Identifier  bigint  NOT NULL ,
	 PRIMARY KEY (Grouping_Identifier ),
	 FOREIGN KEY (Grouping_Identifier) REFERENCES Grouping(Grouping_Identifier)
);


CREATE TABLE Credit_Claim_Amount
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Amount(Claim_Amount_Identifier)
);


CREATE TABLE Expense_Recovery
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Recovery(Claim_Amount_Identifier)
);


CREATE TABLE Renewal
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Policy_Event(Event_Identifier)
);


CREATE TABLE Legal_Jurisdiction
(
	Legal_Jurisdiction_Identifier int  NOT NULL ,
	Legal_Jurisdiction_Name varchar(100)  NULL ,
	Legal_Jurisdiction_Description varchar(2000)  NULL ,
	Rules_Reference_Description varchar(5000)  NULL ,
	 PRIMARY KEY (Legal_Jurisdiction_Identifier )
);


CREATE TABLE Legal_Jurisdiction_Party_Identity
(
	Party_Identifier     bigint  NOT NULL ,
	Legal_Jurisdiction_Identifier int  NOT NULL ,
	Legal_Entity_Type_Code varchar(20)  NULL ,
	Legal_Classification_Code varchar(20)  NULL ,
	Legal_Jurisdiction_Party_Identifier int  NULL ,
	 PRIMARY KEY (Party_Identifier ,Legal_Jurisdiction_Identifier ),
	 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Legal_Jurisdiction_Identifier) REFERENCES Legal_Jurisdiction(Legal_Jurisdiction_Identifier)
);


CREATE TABLE Project
(
	Grouping_Identifier  bigint  NOT NULL ,
	 PRIMARY KEY (Grouping_Identifier ),
	 FOREIGN KEY (Grouping_Identifier) REFERENCES Grouping(Grouping_Identifier)
);

CREATE TABLE Workers_Comp_Class
(
	Insurable_Object_Identifier int  NOT NULL ,
	 PRIMARY KEY (Insurable_Object_Identifier ),
	 FOREIGN KEY (Insurable_Object_Identifier) REFERENCES Insurable_Object(Insurable_Object_Identifier)
);


CREATE TABLE Claim_Reserve
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Amount(Claim_Amount_Identifier)
);


CREATE TABLE Expense_Reserve
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Reserve(Claim_Amount_Identifier)
);


CREATE TABLE Loss_Reserve
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Reserve(Claim_Amount_Identifier)
);


CREATE TABLE Expense_Payment
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Payment(Claim_Amount_Identifier)
);


CREATE TABLE Assesment_Party_Role
(
	Party_Identifier     bigint  NOT NULL ,
	Assessment_Identifier int  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Begin_Date           datetime  NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Party_Identifier ,Assessment_Identifier ,Party_Role_Code ),
	 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Assessment_Identifier) REFERENCES Assessment(Assessment_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);


CREATE TABLE Claim_Assessment
(
	Claim_Identifier     int  NOT NULL ,
	Assessment_Identifier int  NOT NULL ,
	 PRIMARY KEY (Claim_Identifier ,Assessment_Identifier ),
	 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier),
 FOREIGN KEY (Assessment_Identifier) REFERENCES Assessment(Assessment_Identifier)
);


CREATE TABLE Ceded_Claim_Amount
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Amount(Claim_Amount_Identifier)
);


CREATE TABLE Assumed_Claim_Amount
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Amount(Claim_Amount_Identifier)
);


CREATE TABLE Debit_Claim_Amount
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Amount(Claim_Amount_Identifier)
);

CREATE TABLE Loss_Recovery
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Recovery(Claim_Amount_Identifier)
);


CREATE TABLE Direct_Claim_Amount
(
	Claim_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Claim_Amount_Identifier ),
	 FOREIGN KEY (Claim_Amount_Identifier) REFERENCES Claim_Amount(Claim_Amount_Identifier)
);


CREATE TABLE Debit_Policy_Amount
(
	Policy_Amount_Identifier bigint  NOT NULL ,
	 PRIMARY KEY (Policy_Amount_Identifier ),
	 FOREIGN KEY (Policy_Amount_Identifier) REFERENCES Policy_Amount(Policy_Amount_Identifier)
);


CREATE TABLE Claim_Litigation
(
	Claim_Identifier     int  NOT NULL ,
	Litigation_Identifier int  NOT NULL ,
	 PRIMARY KEY (Claim_Identifier ,Litigation_Identifier ),
	 FOREIGN KEY (Litigation_Identifier) REFERENCES Litigation(Litigation_Identifier),
 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier)
);


CREATE TABLE Litigation_Party_Role
(
	Litigation_Identifier int  NOT NULL ,
	Party_Identifier     bigint  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	Begin_Date           datetime  NOT NULL ,
	Claim_Identifier     int  NOT NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Litigation_Identifier ,Party_Identifier ,Party_Role_Code ,Begin_Date ,Claim_Identifier ),
	 FOREIGN KEY (Litigation_Identifier) REFERENCES Litigation(Litigation_Identifier),
 FOREIGN KEY (Party_Identifier) REFERENCES Party(Party_Identifier),
 FOREIGN KEY (Claim_Identifier) REFERENCES Claim(Claim_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);



CREATE TABLE Staff_Work_Assignment
(
	Person_Identifier    bigint  NOT NULL ,
	Organization_Identifier bigint  NOT NULL ,
	Grouping_Identifier  bigint  NOT NULL ,
	Begin_Date           datetime  NOT NULL ,
	Party_Role_Code      varchar(20)  NOT NULL ,
	End_Date             datetime  NULL ,
	 PRIMARY KEY (Person_Identifier ,Organization_Identifier ,Grouping_Identifier ,Begin_Date ,Party_Role_Code ),
	 FOREIGN KEY (Person_Identifier) REFERENCES Person(Person_Identifier),
 FOREIGN KEY (Organization_Identifier) REFERENCES Organization(Organization_Identifier),
 FOREIGN KEY (Grouping_Identifier) REFERENCES Grouping(Grouping_Identifier),
 FOREIGN KEY (Party_Role_Code) REFERENCES Party_Role(Party_Role_Code)
);


CREATE TABLE Pre_Qualification
(
	Event_Identifier     int  NOT NULL ,
	 PRIMARY KEY (Event_Identifier ),
	 FOREIGN KEY (Event_Identifier) REFERENCES Policy_Event(Event_Identifier)
);


CREATE TABLE Reinsurance_Agreement
(
	Agreement_Identifier int  NOT NULL ,
	 PRIMARY KEY (Agreement_Identifier ),
	 FOREIGN KEY (Agreement_Identifier) REFERENCES Agreement(Agreement_Identifier)
);
