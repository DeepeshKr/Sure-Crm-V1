class DistributorMissedOrderType < ActiveRecord::Base
  	has_many :distributor_missed_order, foreign_key: "missed_type_id"
end
# 
# FNAME	VARCHAR2(30 BYTE)	Yes		1
# LNAME	VARCHAR2(30 BYTE)	Yes		2
# ADD1	VARCHAR2(40 BYTE)	Yes		3
# ADD2	VARCHAR2(40 BYTE)	Yes		4
# ADD3	VARCHAR2(40 BYTE)	Yes		5
# CITY	VARCHAR2(20 BYTE)	Yes		6
# PIN	NUMBER(6,0)	Yes		7
# STATE	VARCHAR2(20 BYTE)	Yes		8
# TEL1	VARCHAR2(25 BYTE)	Yes		9
# TEL2	VARCHAR2(15 BYTE)	Yes		10
# FAX	VARCHAR2(20 BYTE)	Yes		11
# EMAIL	VARCHAR2(30 BYTE)	Yes		12
# DEPT	VARCHAR2(20 BYTE)	Yes		13
# PROD	VARCHAR2(7 BYTE)	Yes		14
# QTY	NUMBER(2,0)	Yes		15
# ORDERDATE	DATE	Yes		16
# TRANDATE	DATE	Yes		17
# ORDERSOURCE	VARCHAR2(1 BYTE)	Yes		18
# DEO	VARCHAR2(10 BYTE)	Yes		19
# VPP	NUMBER(1,0)	Yes		20
# OPERATOR	NUMBER(3,0)	Yes		21
# TITLE	VARCHAR2(3 BYTE)	Yes		22
# DISTNAME	VARCHAR2(50 BYTE)	Yes		23
# BASICPRICE	NUMBER(5,0)	Yes		24
# STATUS	VARCHAR2(1 BYTE)	Yes		25
# STATUSDATE	DATE	Yes		26
# DISTCODE	NUMBER(10,0)	Yes		27
# ORDERNO	VARCHAR2(15 BYTE)	Yes		28
# DEBITNOTE	NUMBER(5,0)	Yes		29
# NORMAL	NUMBER(6,0)	Yes		30
# TRANSFER	NUMBER(6,0)	Yes		31
# DEBITNOTEDATE	DATE	Yes		32
# TAXPER	NUMBER(5,2)	Yes		33
# TAXAMT	NUMBER(5,0)	Yes		34
# POSTAGE	NUMBER(5,0)	Yes		35
# INVOICEAMOUNT	NUMBER(5,0)	Yes		36
# DIST	VARCHAR2(1 BYTE)	Yes		37
# DESPATCH	VARCHAR2(3 BYTE)	Yes		38
# MODBY	VARCHAR2(10 BYTE)	Yes		39
# MODDT	DATE	Yes		40
# TRANTYPE	VARCHAR2(1 BYTE)	Yes		41
# CHANNEL	NUMBER(4,0)	Yes		42
# DELVDATE	DATE	Yes		43
# ENTRYDATE	DATE	Yes		44
# CUSTREF	NUMBER(9,0)	Yes		45
# ORDERTYPE	VARCHAR2(1 BYTE)	Yes		46
# MANIFEST	VARCHAR2(8 BYTE)	Yes		47
# TEMPSTATUS	VARCHAR2(1 BYTE)	Yes		48
# TEMPSTATUSDATE	DATE	Yes		49
# LOYDATE	DATE	Yes		50
# LANDMARK	VARCHAR2(30 BYTE)	Yes		51
# TEMPTRANDATE	DATE	Yes		52
# INVDATE	DATE	Yes		53
# ACTDATE	DATE	Yes		54
# ACTION	VARCHAR2(10 BYTE)	Yes		55
# LESSPROD	VARCHAR2(6 BYTE)	Yes		56
# REMARKS	VARCHAR2(30 BYTE)	Yes		57
# BARCODE	VARCHAR2(25 BYTE)	Yes		58
# BARCODE2	VARCHAR2(25 BYTE)	Yes		59
# BARCODE3	VARCHAR2(25 BYTE)	Yes		60
# CODAMT	NUMBER(2,0)	Yes		61
# WEIGHT	NUMBER(6,2)	Yes		62
# DT_HOUR	VARCHAR2(2 BYTE)	Yes		63
# DT_MIN	VARCHAR2(2 BYTE)	Yes		64
# CONVCHARGES	NUMBER(5,0)	Yes		65
