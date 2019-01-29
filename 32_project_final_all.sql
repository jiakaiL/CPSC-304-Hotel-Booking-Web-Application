-- ============================= 下面这段 sql 在 sqlplus 上测试通过 =======================
-- Edit: Kai 2018-03-27 division query 会出john
-- Edit: XSH 2018-03-22 18:25:00
SET pagesize 100;
SET lin 1000;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Member CASCADE CONSTRAINTS;
DROP TABLE GeoInfo CASCADE CONSTRAINTS;
DROP TABLE Hotel CASCADE CONSTRAINTS;
DROP TABLE RoomType CASCADE CONSTRAINTS;
Drop TABLE RtPlan CASCADE CONSTRAINTS;
Drop TABLE Reservation CASCADE CONSTRAINTS;
Drop TABLE HotelStay CASCADE CONSTRAINTS;
Drop TABLE Makes CASCADE CONSTRAINTS;
Drop TABLE Room CASCADE CONSTRAINTS;
Drop TABLE Stays CASCADE CONSTRAINTS;
Drop TABLE ShuttleService CASCADE CONSTRAINTS;
drop sequence cofNo_seq;
create sequence cofNo_seq start with 100011 increment by 1;
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI';

-- ---------------- Table Creation ------------------------

CREATE TABLE Customer (
	CID			CHAR(11),
	Name		VARCHAR(40),
	Ph			CHAR(10),
	Email		VARCHAR(50),
	PRIMARY KEY (CID));

CREATE TABLE Member (
	CID			CHAR(11),
	Pt			INT,
	PRIMARY KEY (CID),
	FOREIGN KEY (CID) REFERENCES Customer ON DELETE CASCADE);

CREATE TABLE GeoInfo (
	Country		VARCHAR(20),
	PostCode	VARCHAR(10),
	City		VARCHAR(20),
	Prov		VARCHAR(20),
	PRIMARY KEY (Country, PostCode));

CREATE TABLE Hotel (
	HID			CHAR(11),
	HName		VARCHAR(20),
	StNo		VARCHAR(5),
	StName		VARCHAR(20),
	Country		VARCHAR(20),
	PostCode	VARCHAR(10),
	PRIMARY KEY (HID),
	FOREIGN KEY (Country, PostCode) REFERENCES GeoInfo ON DELETE SET NULL);

CREATE TABLE RoomType (
	TID		CHAR(11),
	BedSize		VARCHAR(8),
	BedNum		INT,
	RmView		VARCHAR(8),
	PRIMARY KEY (TID));

CREATE TABLE RtPlan (
	HID			CHAR(11),
	TID			CHAR(11),
	RegRt		DECIMAL(6,2),
	PRIMARY KEY (HID, TID),
	FOREIGN KEY (HID) REFERENCES Hotel ON DELETE CASCADE,
	FOREIGN KEY (TID) REFERENCES RoomType ON DELETE CASCADE);

CREATE TABLE Reservation (
	CofNo		 CHAR(11),
  Status	 CHAR(11),
  CCNo		 CHAR(16),
  CCExp		 CHAR(4),
	CCName		VARCHAR(20),
	CInDate		DATE,
	COutDate	DATE,
  PRIMARY KEY (CofNo),
  Check (CInDate < COutDate and (substr(CCExp,3,2)||substr(CCExp, 1,2))>1208));

CREATE TABLE HotelStay (
	HSID		CHAR(11),
	Deposit		NUMBER(1,0),
	Payment		NUMBER(1,0),
	Dinner		DECIMAL(6,2),
	Parking		DECIMAL(6,2),
  Pet			DECIMAL(6,2),
	Wifi		DECIMAL(6,2),
  Luggage		NUMBER(1,0),
  AInDate		DATE,
  AOutDate	DATE,
  CofNo 		CHAR(11),
  PRIMARY KEY (HSID),
  UNIQUE (CofNo),
	FOREIGN KEY (CofNo) REFERENCES Reservation ON DELETE CASCADE);

CREATE TABLE Makes (
	CID		CHAR(11),
  HID		CHAR(11),
	TID		CHAR(11),
	CofNo	CHAR(11),
	PRIMARY KEY (CID, HID, TID, CofNo),
	FOREIGN KEY (CID) REFERENCES Customer ON DELETE CASCADE,
	FOREIGN KEY (TID) REFERENCES RoomType ON DELETE CASCADE,
	FOREIGN KEY (CofNo) REFERENCES Reservation ON DELETE CASCADE,
	FOREIGN KEY (HID) REFERENCES Hotel ON DELETE CASCADE);

CREATE TABLE Room(
    HID     CHAR(11),
    RoomNo  VARCHAR(4),
    TID     CHAR(11) NOT NULL,
    PRIMARY KEY (HID, RoomNo),
    FOREIGN KEY (HID) REFERENCES Hotel ON DELETE CASCADE,
    FOREIGN KEY (TID) REFERENCES RoomType ON DELETE CASCADE);

 CREATE TABLE Stays (
	CID	CHAR(11),
	HSID	CHAR(11),
	HID	CHAR(11),
	RoomNo	VARCHAR(4),
	PRIMARY KEY (CID, HSID, HID, RoomNo),
	FOREIGN KEY (CID) REFERENCES Customer ON DELETE CASCADE,
	FOREIGN KEY (HSID) REFERENCES HotelStay ON DELETE CASCADE,
	FOREIGN KEY (HID, RoomNo) REFERENCES Room ON DELETE CASCADE);

CREATE TABLE ShuttleService (
	SID		CHAR(11),
	Dir		CHAR(11),
	sDateTime		DATE,
	FlightNo	VARCHAR(6),
	HSID		CHAR(11) NOT NULL,
	PRIMARY KEY (SID),
	FOREIGN KEY (HSID) REFERENCES HotelStay ON DELETE CASCADE);



-- -------------------- Data Initialization -----------------------------
INSERT INTO Customer
VALUES ('1', 'Jack', '6042223333', 'jack@email.com');

INSERT INTO Customer
VALUES ('2', 'Phoebe', '7781112222', 'pheobe@email.com');

INSERT INTO Customer
VALUES ('3', 'Anna', '7042223333', 'sam.and.anna@email.com');

INSERT INTO Customer
VALUES ('4', 'Sam', '7042223333', 'sam.and.anna@email.com');

INSERT INTO Customer
VALUES ('5', 'John', '8881119993', 'john@email.com');

INSERT INTO Customer
VALUES ('6', 'Alice', '7781250088', 'alice@email.com');

INSERT INTO Customer
VALUES ('7', 'Frank', '3301113333', 'frank@email.com');

INSERT INTO Member
VALUES ('1', 0);

INSERT INTO Member
VALUES ('2', 80);

INSERT INTO Member
VALUES ('4', 480);

INSERT INTO Member
VALUES ('5', 160);

INSERT INTO Member
VALUES ('6', 20160);

INSERT INTO GeoInfo
VALUES ('Canada', 'T2H8Y7', 'Toronto', 'Ontario');

INSERT INTO GeoInfo
VALUES ('Canada', 'M7Y3K9', 'Victoria', 'British Columbia');

INSERT INTO GeoInfo
VALUES ('China', '210009', 'Nanjing', 'Jiangsu');

INSERT INTO GeoInfo
VALUES ('China', '200003', 'Shanghai', 'Shanghai');

INSERT INTO GeoInfo
VALUES ('United States', '90009', 'Los Angeles', 'California');

INSERT INTO Hotel
VALUES ('1', 'Holiday Sea', '111', 'Semour St', 'Canada', 'T2H8Y7');

INSERT INTO Hotel
VALUES ('2', 'Sunshine Bay', '222', 'Sunshine Blvd', 'Canada', 'M7Y3K9');

INSERT INTO Hotel
VALUES ('3', 'Great Beach', '333', 'Beackon Way', 'United States', '90009');

INSERT INTO Hotel
VALUES ('4', 'Park View', '111', 'He Ping Li', 'China', '200003');

INSERT INTO Hotel
VALUES ('5', 'Lake Palace', '222', 'Zhong Shan Lu', 'China', '210009');

INSERT INTO RoomType
VALUES ('1', 'King', 1, 'Water');

INSERT INTO RoomType
VALUES ('2', 'King', 1, 'Street');

INSERT INTO RoomType
VALUES ('3', 'Queen', 2, 'Water');

INSERT INTO RoomType
VALUES ('4', 'Queen', 2, 'Street');

INSERT INTO RoomType
VALUES ('5', 'Double', 2, 'Water');

INSERT INTO RoomType
VALUES ('6', 'Double', 2, 'Street');

INSERT INTO RtPlan
VALUES ('1','1','400');

INSERT INTO RtPlan
VALUES ('1','2','350');

INSERT INTO RtPlan
VALUES ('1','3','300');

INSERT INTO RtPlan
VALUES ('1','4','250');

INSERT INTO RtPlan
VALUES ('1','5','200');

INSERT INTO RtPlan
VALUES ('1','6','150');

INSERT INTO RtPlan
VALUES ('2','1','380');

INSERT INTO RtPlan
VALUES ('2','2','340');

INSERT INTO RtPlan
VALUES ('2','3','290');

INSERT INTO RtPlan
VALUES ('2','4','220');

INSERT INTO RtPlan
VALUES ('2','5','180');

INSERT INTO RtPlan
VALUES ('2','6','100');

INSERT INTO RtPlan
VALUES ('3','1','400');

INSERT INTO RtPlan
VALUES ('3','2','350');

INSERT INTO RtPlan
VALUES ('3','3','300');

INSERT INTO RtPlan
VALUES ('3','4','250');

INSERT INTO RtPlan
VALUES ('3','5','200');

INSERT INTO RtPlan
VALUES ('3','6','150');

INSERT INTO RtPlan
VALUES ('4','1','300');

INSERT INTO RtPlan
VALUES ('4','2','300');

INSERT INTO RtPlan
VALUES ('4','3','200');

INSERT INTO RtPlan
VALUES ('4','4','200');

INSERT INTO RtPlan
VALUES ('4','5','100');

INSERT INTO RtPlan
VALUES ('4','6','100');

INSERT INTO RtPlan
VALUES ('5','1','300');

INSERT INTO RtPlan
VALUES ('5','2','280');

INSERT INTO RtPlan
VALUES ('5','3','250');

INSERT INTO RtPlan
VALUES ('5','4','250');

INSERT INTO RtPlan
VALUES ('5','5','150');

INSERT INTO RtPlan
VALUES ('5','6','100');

INSERT INTO Reservation
VALUES ('100001', 'Completed', '2987492834891908', '0722', 'John', TIMESTAMP '2016-01-02 15:00:00', TIMESTAMP '2016-01-06 12:00:00');

INSERT INTO Reservation
VALUES ('100002', 'Completed', '2938484839485838', '0818', 'Alice', TIMESTAMP '2016-03-12 15:00:00', TIMESTAMP '2016-06-20 12:00:00');

INSERT INTO Reservation
VALUES ('100003', 'Completed', '8475843928743846', '1219', 'Sam', TIMESTAMP '2017-09-29 15:00:00', TIMESTAMP '2017-10-01 12:00:00');

INSERT INTO Reservation
VALUES ('100004', 'Completed', '2938484839485838', '0818', 'Alice', TIMESTAMP '2017-07-27 15:00:00', TIMESTAMP'2017-07-31 12:00:00');

INSERT INTO Reservation
VALUES ('100005', 'Completed', '9555555566666444', '1021', 'Alice', TIMESTAMP '2016-12-01 15:00:00', TIMESTAMP'2016-12-08 12:00:00');

INSERT INTO Reservation
VALUES ('100006', 'Completed', '9555555566666444', '1021', 'Alice', TIMESTAMP '2018-01-01 15:00:00', TIMESTAMP'2018-01-08 12:00:00');

INSERT INTO Reservation
VALUES ('100007', 'Completed', '2938484839485838', '0818', 'Alice', TIMESTAMP '2018-02-03 15:00:00', TIMESTAMP'2018-02-13 12:00:00');

INSERT INTO Reservation
VALUES ('100008', 'Cancelled', '3847493938483847', '1019', 'Jack', TIMESTAMP '2017-12-13 15:00:00', TIMESTAMP'2018-01-03 12:00:00');

INSERT INTO Reservation
VALUES ('100009', 'Completed', '8475843928743846', '1219', 'Sam', TIMESTAMP '2016-05-10 15:00:00', TIMESTAMP'2016-05-23 12:00:00');

INSERT INTO Reservation
VALUES ('100010', 'Active', '8464784726947373', '0922', 'Alice', TIMESTAMP '2018-12-21 15:00:00', TIMESTAMP'2100-09-08 12:00:00');

INSERT INTO HotelStay
VALUES ('1233', '1', '1', '100', '10', '100', '10', '0', TIMESTAMP '2016-01-02 15:00:00', TIMESTAMP '2016-01-06 12:00:00', '100001');

INSERT INTO HotelStay
VALUES ('1234', '1', '1', '0', '10', '100', '10', '0', TIMESTAMP '2016-03-12 15:00:00', TIMESTAMP '2016-06-20 12:00:00', '100002');

INSERT INTO HotelStay
VALUES ('1235', '1', '1', '98', '0', '200', '10', '1', TIMESTAMP '2017-09-29 15:00:00', TIMESTAMP '2017-10-01 12:00:00', '100003');

INSERT INTO HotelStay
VALUES ('1236', '1', '1', '0', '10', '0', '0', '0', TIMESTAMP '2017-07-27 15:00:00', TIMESTAMP '2017-07-31 12:00:00', '100004');

INSERT INTO HotelStay
VALUES ('1237', '1', '1', '80', '10', '0', '0', '1', TIMESTAMP '2016-12-01 15:00:00', TIMESTAMP '2016-12-08 12:00:00', '100005');

INSERT INTO HotelStay
VALUES ('1238', '1', '1', '0', '0', '0', '0', '0', TIMESTAMP '2018-01-01 15:00:00', TIMESTAMP '2018-01-08 12:00:00', '100006');

INSERT INTO HotelStay
VALUES ('1239', '1', '1', '0', '0', '0', '0', '0', TIMESTAMP '2018-02-03 15:00:00', TIMESTAMP '2018-02-13 12:00:00', '100007');

INSERT INTO HotelStay
VALUES ('1240', '1', '1', '0', '0', '0', '0', '0', TIMESTAMP '2016-05-10 15:00:00', TIMESTAMP '2016-05-23 12:00:00', '100009');

INSERT INTO HotelStay
VALUES ('1241', '1', '1', '0', '0', '0', '0', '0', TIMESTAMP '2018-02-04 15:00:00', TIMESTAMP '2018-02-05 12:00:00', NULL);

INSERT INTO HotelStay
VALUES ('1242', '1', '1', '100', '10', '100', '0', '0', TIMESTAMP '2018-02-04 15:00:00', TIMESTAMP '2018-02-05 12:00:00', NULL);
INSERT INTO HotelStay
VALUES ('1243', '1', '1', '200', '10', '100', '0', '0', TIMESTAMP '2017-08-15 15:00:00', TIMESTAMP '2017-08-16 12:00:00', NULL);
INSERT INTO HotelStay
VALUES ('1244', '1', '1', '100', '10', '100', '0', '0', TIMESTAMP '2017-04-09 15:00:00', TIMESTAMP '2017-04-10 12:00:00', NULL);
INSERT INTO HotelStay
VALUES ('1245', '1', '1', '200', '10', '100', '0', '0', TIMESTAMP '2017-05-09 15:00:00', TIMESTAMP '2017-05-10 12:00:00', NULL);

INSERT INTO Makes
VALUES ('5', '5', '3', '100001');

INSERT INTO Makes
VALUES ('6', '1', '1', '100002');

INSERT INTO Makes
VALUES ('4', '3', '3', '100003');

INSERT INTO Makes
VALUES ('6', '1', '1', '100004');

INSERT INTO Makes
VALUES ('6', '1', '1', '100005');

INSERT INTO Makes
VALUES ('6', '1', '1', '100006');

INSERT INTO Makes
VALUES ('6', '1', '1', '100007');

INSERT INTO Makes
VALUES ('1', '5', '6', '100008');

INSERT INTO Makes
VALUES ('4', '1', '5', '100009');

INSERT INTO Makes
VALUES ('6', '1', '1', '100010');

INSERT INTO Room
VALUES('1', '101', '1');

INSERT INTO Room
VALUES('1', '102', '2');

INSERT INTO Room
VALUES('1', '201', '3');

INSERT INTO Room
VALUES('1', '202', '4');

INSERT INTO Room
VALUES('1', '301', '5');

INSERT INTO Room
VALUES('1', '302', '6');

INSERT INTO Room
VALUES('2', '101', '1');

INSERT INTO Room
VALUES('2', '102', '2');

INSERT INTO Room
VALUES('2', '201', '3');

INSERT INTO Room
VALUES('2', '202', '4');

INSERT INTO Room
VALUES('2', '301', '5');

INSERT INTO Room
VALUES('2', '302', '6');

INSERT INTO Room
VALUES('3', '101', '1');

INSERT INTO Room
VALUES('3', '102', '2');

INSERT INTO Room
VALUES('3', '201', '3');

INSERT INTO Room
VALUES('3', '202', '4');

INSERT INTO Room
VALUES('3', '301', '5');

INSERT INTO Room
VALUES('3', '302', '6');

INSERT INTO Room
VALUES('4', '101', '1');

INSERT INTO Room
VALUES('4', '102', '2');

INSERT INTO Room
VALUES('4', '201', '3');

INSERT INTO Room
VALUES('4', '202', '4');

INSERT INTO Room
VALUES('4', '301', '5');

INSERT INTO Room
VALUES('4', '302', '6');

INSERT INTO Room
VALUES('5', '101', '1');

INSERT INTO Room
VALUES('5', '102', '2');

INSERT INTO Room
VALUES('5', '201', '3');

INSERT INTO Room
VALUES('5', '202', '4');

INSERT INTO Room
VALUES('5', '301', '5');

INSERT INTO Room
VALUES('5', '302', '6');

INSERT INTO Stays
VALUES ('5', '1233', '5', '201');

INSERT INTO Stays
VALUES ('6', '1234', '1', '101');

INSERT INTO Stays
VALUES ('4', '1235', '3', '201');

INSERT INTO Stays
VALUES ('3', '1235', '3', '201');

INSERT INTO Stays
VALUES ('6', '1236', '1', '101');

INSERT INTO Stays
VALUES ('6', '1237', '1', '101');

INSERT INTO Stays
VALUES ('6', '1238', '1', '101');

INSERT INTO Stays
VALUES ('6', '1239', '1', '101');

INSERT INTO Stays
VALUES ('4', '1240', '1', '301');

INSERT INTO Stays
VALUES ('7', '1241', '5', '302');

INSERT INTO Stays
VALUES ('5', '1242', '1', '102');

INSERT INTO Stays
VALUES ('5', '1243', '2', '301');

INSERT INTO Stays
VALUES ('5', '1244', '3', '102');

INSERT INTO Stays
VALUES ('5', '1245', '4', '301');

INSERT INTO ShuttleService
VALUES ('10001', 'Pickup', TIMESTAMP '2016-01-02 08:00:00', 'AB122', '1233');

INSERT INTO ShuttleService
VALUES ('10002', 'Drop-off', TIMESTAMP '2016-06-20 14:00:00', 'AP123', '1234');

INSERT INTO ShuttleService
VALUES ('10003', 'Pickup', TIMESTAMP '2017-09-29 12:00:00', 'SO877', '1235');

INSERT INTO ShuttleService
VALUES ('10004', 'Drop-off', TIMESTAMP '2017-07-31 02:00:00', 'SN099', '1236');

INSERT INTO ShuttleService
VALUES ('10005', 'Drop-off', TIMESTAMP '2016-12-08 18:00:00', 'OL388', '1237');

grant all on Customer to public;
grant all on Member to public;
grant all on GeoInfo to public;
grant all on Hotel to public;
grant all on RoomType to public;
grant all on RtPlan to public;
grant all on Reservation to public;
grant all on HotelStay to public;
grant all on Makes to public;
grant all on Room to public;
grant all on Stays to public;
grant all on ShuttleService to public;
