
CREATE PROCEDURE wrapper_USER
@RUN INT
AS
DECLARE 
@UserTypeName varchar(50),
@UserBeginDate DATE,
@FirstName varchar(25),
@LastName varchar(25),
@BirthDate DATE,
@eMail VARCHAR(100),
@UserCount INT,
@UserTypeCount INT = (SELECT COUNT(*) FROM USER_TYPE),
@UserTypeID INT,
@Rand Numeric(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @UserTypeID = (@Rand * @UserTypeCount + 1)
SET @UserTypeName = (SELECT UserTypeName FROM USER_TYPE WHERE UserTypeID = @UserTypeID)
SET @UserCount = (SELECT COUNT(*) + 1 FROM [USER])
SET @FirstName = 'First' + CAST(@UserCount as varchar(50))
SET @LastName = 'Last' + CAST(@UserCount as varchar(50))
SET @BirthDate = (SELECT DATEADD(YEAR, - @Rand * 50, GETDATE()))
SET @UserBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 120, GETDATE()))
SET @eMail = @FirstName + '@gmail.com'
EXEC usp_USER
@UserTypeName = @UserTypeName,
@UserBeginDate = @UserBeginDate,
@FirstName = @FirstName,
@LastName = @LastName,
@BirthDate = @BirthDate,
@eMail = @eMail
SET @RUN = @RUN - 1
END
GO

CREATE PROCEDURE Wrapper_TEAM
@RUN INT
AS 
DECLARE 
@TeamName VARCHAR(50),
@TeamBeginDate DATE,
@TeamTypeName VARCHAR(50),
@TeamTypeCount INT = (SELECT COUNT(*) FROM TEAM_TYPE),
@TeamTypeID INT,
@TeamCount INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN 
SET @Rand = (SELECT RAND())
SET @TeamTypeID = (@RAND *@TeamTypeCount + 1)
SET @TeamCount = (SELECT COUNT(*) FROM TEAM) + 1
SET @TeamName = 'Team' + CAST(@TeamCount as varchar(50))
SET @TeamTypeID = (@Rand * @TeamTypeCount + 1)
SET @TeamTypeName = (SELECT TeamTypeName FROM TEAM_TYPE WHERE TeamTypeID = @TeamTypeID)
SET @TeamBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 120, GETDATE()))
EXEC usp_TEAM
@TeamName = @TeamName,
@TeamBeginDate = @TeamBeginDate,
@TeamTypeName = @TeamTypeName
SET @RUN = @RUN - 1
END
GO

CREATE PROCEDURE Wrapper_USER_TEAM_ROLE
@RUN INT
AS 
DECLARE
@TeamName varchar(50),
@RoleName varchar(50),
@eMail varchar(100),
@UTRBeginDate DATE,
@TeamCount INT = (SELECT COUNT(*) FROM TEAM),
@RoleCount INT = (SELECT COUNT(*) FROM [ROLE]),
@UserCount INT = (SELECT COUNT(*) FROM [USER]),
@UserBeginDate DATE,
@TeamBeginDate DATE,
@TeamID INT,
@RoleID INT,
@UserID INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @TeamID = (@Rand * @TeamCount + 1)
SET @Rand = (SELECT RAND())
SET @RoleID = (@Rand * @RoleCount + 1)
SET @Rand = (SELECT RAND())
SET @UserID = (@Rand * @UserCount + 1)
SET @TeamName = (SELECT TeamName FROM [TEAM] WHERE TeamID = @TeamID)
SET @RoleName = (SELECT RoleName FROM [ROLE] WHERE RoleID = @RoleID)
SET @eMail = (SELECT eMail FROM [USER] WHERE UserID = @UserID)
SET @UserBeginDate = (SELECT UserBeginDate FROM [USER] WHERE UserID = @UserID)
SET @TeamBeginDate = (SELECT TeamBeginDate FROM TEAM WHERE TeamID = @TeamID)
SET @UTRBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 60, GETDATE()))
WHILE (@UTRBeginDate < @UserBeginDate AND @UTRBeginDate < @TeamBeginDate)
BEGIN
SET @Rand = (SELECT RAND())
SET @UTRBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 60, GETDATE()))
END
EXEC usp_USER_TEAM_ROLE
@eMail = @eMail,
@RoleName = @RoleName,
@TeamName = @TeamName,
@UTRBeginDate = @UTRBeginDate
SET @RUN = @RUN - 1
END
GO

CREATE PROCEDURE Wrapper_PRIZE
@RUN INT 
AS 
DECLARE 
@PrizeName varchar(50),
@PrizePoints numeric(5,0),
@PrizeTypeName varchar(50),
@PrizeDate DATE,
@PrizeCount INT,
@PrizeTypeCount INT = (SELECT COUNT(*) FROM PRIZE_TYPE),
@PrizeTypeID INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0 
BEGIN
SET @PrizeCount = (SELECT COUNT(*) FROM PRIZE) + 1
SET @Rand = (SELECT RAND())
SET @PrizeTypeID = (@PrizeTypeCount * @Rand + 1)
SET @PrizeName = 'Prize' + CAST(@PrizeCount as varchar(50))
SET @PrizePoints = (@Rand * 1000)
SET @PrizeDate = (SELECT DATEADD(MONTH, -@Rand*1000, GETDATE()))
SET @PrizeTypeName = (SELECT PrizeTypeName FROM PRIZE_TYPE WHERE PrizeTypeID = @PrizeTypeID)
EXEC usp_PRIZE
@PrizeName = @PrizeName,
@PrizePoints = @PrizePoints,
@PrizeTypeName = @PrizeTypeName,
@PrizeDate = @PrizeDate
SET @RUN = @RUN - 1
END
GO


CREATE PROCEDURE Wrapper_USER_TEAM_ROLE_REDEMPTION
@RUN INT
AS
DECLARE
@RedemptionName VARCHAR(50),
@RedemptionDate DATE,
@PrizeName varchar(50),
@PrizeCount INT = (SELECT COUNT(*) FROM PRIZE),
@PrizeID INT,
@UserTeamRoleCount INT = (SELECT COUNT(*) FROM USER_TEAM_ROLE),
@UserTeamRoleID INT,
@UserID INT,
@TeamID INT,
@RoleID INT,
@TeamName varchar(50),
@RoleName varchar(50),
@eMail varchar(100),
@UTRBeginDate DATE,
@RedemptionCount INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @RedemptionCount = (SELECT COUNT(*) FROM REDEMPTION) + 1
SET @Rand = (SELECT RAND())
SET @PrizeID = (@PrizeCount * @Rand + 1)
SET @Rand = (SELECT RAND())
SET @UserTeamRoleID = (@UserTeamRoleCount * @Rand + 1)
SET @RedemptionName = 'Redemption' + CAST(@RedemptionCount as varchar(50))
SET @PrizeName = (SELECT PrizeName FROM PRIZE WHERE PrizeID = @PrizeID)
SET @RedemptionDate = (SELECT DATEADD(MONTH, - @Rand * 1000, GETDATE()))
SET @UTRBeginDate = (SELECT UTRBeginDate FROM USER_TEAM_ROLE WHERE UserTeamRoleID = @UserTeamRoleID)
WHILE @RedemptionDate < @UTRBeginDate
BEGIN
SET @Rand = (SELECT RAND())
SET @RedemptionDate = (SELECT DATEADD(MONTH, - @Rand * 1000, GETDATE()))
END
EXEC usp_REDEMPTION
@RedemptionName = @RedemptionName,
@RedemptionDate = @RedemptionDate,
@PrizeName = @PrizeName
SET @UserID = (SELECT UserID FROM USER_TEAM_ROLE WHERE UserTeamRoleID = @UserTeamRoleID)
SET @TeamID = (SELECT TeamID FROM USER_TEAM_ROLE WHERE UserTeamRoleID = @UserTeamRoleID)
SET @RoleID = (SELECT RoleID FROM USER_TEAM_ROLE WHERE UserTeamRoleID = @UserTeamRoleID)
SET @TeamName = (SELECT TeamName FROM TEAM WHERE TeamID = @TeamID)
SET @eMail = (SELECT eMail FROM [USER] WHERE UserID = @UserID)
SET @RoleName = (SELECT RoleName FROM [ROLE] WHERE RoleID = @RoleID)
EXEC usp_USER_TEAM_ROLE_REDEMPTION
@RedemptionName = @RedemptionName,
@TeamName = @TeamName,
@eMail = @eMail,
@RoleName = @RoleName
SET @RUN = @RUN -1
END
GO

CREATE PROCEDURE wrapper_Institution
@RUN INT
AS
DECLARE
@InstitutionTypeName varchar(50),
@InstitutionName VARCHAR(50),
@InstitutionBeginDate DATE,
@InstitutionTypeCount INT = (SELECT COUNT(*) FROM INSTITUTION_TYPE),
@InstitutionTypeID INT,
@InstitutionCount INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @InstitutionTypeID = (@InstitutionTypeCount * @Rand + 1)
SET @InstitutionCount = (SELECT COUNT(*) FROM INSTITUTION)
SET @InstitutionName = 'Institution' + CAST(@InstitutionCount as varchar(50)) 
SET @InstitutionTypeName = (SELECT InstitutionTypeName FROM INSTITUTION_TYPE WHERE InstitutionTypeID = @InstitutionTypeID)
SET @InstitutionBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 180, GETDATE()))
EXEC usp_INSTITUTION
@InstitutionTypeName = @InstitutionTypeName,
@InstitutionName = @InstitutionName,
@InstitutionBeginDate = @InstitutionBeginDate
SET @RUN = @RUN - 1
END
GO

CREATE PROCEDURE wrapper_GROUP
@RUN INT
AS
DECLARE
@InstitutionName VARCHAR(50),
@GroupTypeName VARCHAR(50),
@GroupName VARCHAR(50),
@GroupBeginDate DATE,
@InstitutionCount INT = (SELECT COUNT(*) FROM INSTITUTION),
@InstitutionID INT,
@InstitutionBeginDate DATE,
@GroupTypeCount INT = (SELECT COUNT(*) FROM GROUP_TYPE),
@GroupTypeID INT,
@GroupCount INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @GroupCount = (SELECT COUNT(*) FROM [GROUP]) + 1
SET @InstitutionID = (@Rand * @InstitutionCount + 1)
SET @Rand = (SELECT RAND())
SET @GroupTypeID = (@Rand * @GroupTypeCount + 1)
SET @GroupName = 'Group' + CAST(@GroupCount as varchar(50))
SET @InstitutionName = (SELECT InstitutionName FROM INSTITUTION WHERE InstitutionID = @InstitutionID)
SET @GroupTypeName = (SELECT GroupTypeName FROM GROUP_TYPE WHERE GroupTypeID = @GroupTypeID)
SET @GroupBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000, GETDATE()))
SET @InstitutionBeginDate = (SELECT InstitutionBeginDate FROM INSTITUTION WHERE InstitutionID = @InstitutionID)
WHILE @InstitutionBeginDate < @GroupBeginDate
BEGIN
SET @Rand = (SELECT RAND())
SET @GroupBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 90, GETDATE()))
END
EXEC usp_GROUP
@InstitutionName = @InstitutionName,
@GroupTypeName = @GroupTypeName,
@GroupName = @GroupName,
@GroupBeginDate = @GroupBeginDate
SET @RUN = @RUN - 1
END
GO

CREATE PROCEDURE wrapper_PROJECT
@RUN INT
AS
DECLARE
@ProjectName VARCHAR(50),
@ProjectTypeName VARCHAR(50),
@ProjectBeginDate DATE,
@GroupName VARCHAR(50),
@GroupCount INT = (SELECT COUNT(*) FROM [GROUP]),
@GroupID INT,
@GroupBeginDate DATE,
@ProjectTypeCount INT = (SELECT COUNT(*) FROM PROJECT_TYPE),
@ProjectTypeID INT,
@ProjectCount INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @ProjectCount = (SELECT COUNT(*) FROM PROJECT) + 1
SET @GroupID = (@Rand * @GroupCount + 1) 
SET @Rand = (SELECT RAND())
SET @ProjectTypeID = (@Rand * @ProjectTypeCount + 1)
SET @GroupName = (SELECT GroupName FROM [GROUP] WHERE GroupID = @GroupID)
SET @ProjectTypeName = (SELECT ProjectTypeName FROM PROJECT_TYPE WHERE ProjectTypeID = @ProjectTypeID)
SET @ProjectName = 'Project' + CAST(@ProjectCount as varchar(50))
SET @ProjectBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 45, GETDATE()))
SET @GroupBeginDate = (SELECT GroupBeginDate FROM [GROUP] WHERE GroupID = @GroupID)
WHILE @GroupBeginDate < @ProjectBeginDate
BEGIN
SET @Rand = (SELECT RAND())
SET @ProjectBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 45, GETDATE()))
END
EXEC usp_PROJECT
@ProjectName = @ProjectName,
@ProjectTypeName = @ProjectTypeName,
@ProjectBeginDate = @ProjectBeginDate,
@GroupName = @GroupName
SET @RUN = @RUN - 1
END
GO

CREATE PROCEDURE wrapper_TASK
@RUN INT
AS
DECLARE 
@TaskTypeName VARCHAR(50),
@TaskTypeCount INT = (SELECT COUNT(*) FROM TASK_TYPE),
@TaskTypeID INT,
@TaskName VARCHAR(50),
@TaskCount INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @TaskTypeID = (@Rand * @TaskTypeCount + 1)
SET @TaskCount = (SELECT COUNT(*) FROM TASK) + 1
SET @TaskTypeName = (SELECT TaskTypeName FROM TASK_TYPE WHERE TaskTypeID = @TaskTypeID)
SET @TaskName = 'Task' + CAST(@TaskCount as varchar(50))
EXEC usp_TASK
@TaskName = @TaskName,
@TaskTypeName = @TaskTypeName
SET @RUN = @RUN - 1 
END
GO

CREATE PROCEDURE wrapper_PROJECT_TASK
@RUN INT 
AS 
DECLARE
@ProjectName VARCHAR(50),
@TaskName VARCHAR(50),
@ProjectCount INT = (SELECT COUNT(*) FROM PROJECT),
@ProjectID INT,
@ProjectBeginDate DATE,
@TaskCount INT = (SELECT COUNT(*) FROM TASK),
@TaskID INT,
@ProjectTaskDate DATE,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @ProjectID = (@ProjectCount * @Rand + 1)
SET @Rand = (SELECT RAND())
SET @TaskID = (@TaskCount * @Rand + 1)
SET @ProjectName = (SELECT ProjectName FROM PROJECT WHERE ProjectID = @ProjectID)
SET @ProjectBeginDate = (SELECT ProjectBeginDate FROM PROJECT WHERE ProjectID = @ProjectID)
SET @TaskName = (SELECT TaskName FROM TASK WHERE TaskID = @TaskID)
SET @ProjectTaskDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 20, GETDATE()))
WHILE @ProjectBeginDate > @ProjectTaskDate
BEGIN
SET @Rand = (SELECT RAND())
SET @ProjectTaskDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 20, GETDATE()))
END
EXEC usp_PROJECT_TASK
@ProjectName = @ProjectName,
@TaskName = @TaskName,
@ProjectTaskDate = @ProjectTaskDate
SET @RUN = @RUN - 1
END
GO

ALTER PROCEDURE wrapper_USER_TEAM_ROLE_ACTION_TASK
@RUN INT
AS
DECLARE
@eMail VARCHAR(100),
@TeamName VARCHAR(50),
@RoleName VARCHAR(50),
@ActionName VARCHAR(50),
@TaskName VARCHAR(50),
@UTRATBeginDate DATE,
@UTRATDueDate DATE,
@Points Numeric(5,2),
@UserTeamRoleCount INT = (SELECT COUNT(*) FROM USER_TEAM_ROLE),
@UserTeamRoleID INT,
@UTRBeginDate DATE,
@UserID INT,
@TeamID INT,
@RoleID INT,
@ActionCount INT = (SELECT COUNT(*) FROM [ACTION]),
@ActionID INT,
@TaskCount INT = (SELECT COUNT(*) FROM TASK),
@TaskID INT, 
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @ActionID = (@Rand * @ActionCount + 1)
SET @Rand = (SELECT RAND())
SET @TaskID = (@Rand * @TaskCount + 1)
SET @Rand = (SELECT RAND())
SET @UserTeamRoleID = (@Rand * @UserTeamRoleCount + 1)
SET @UserID = (SELECT UserID FROM USER_TEAM_ROLE WHERE UserTeamRoleID = @UserTeamRoleID)
SET @TeamID = (SELECT TeamID FROM USER_TEAM_ROLE WHERE UserTeamRoleID = @UserTeamRoleID)
SET @RoleID = (SELECT RoleID FROM USER_TEAM_ROLE WHERE UserTeamRoleID = @UserTeamRoleID)
SET @UTRBeginDate = (SELECT UTRBeginDate FROM USER_TEAM_ROLE WHERE UserTeamRoleID = @UserTeamRoleID)
SET @eMail = (SELECT eMail FROM [USER] WHERE UserID = @UserID)
SET @TeamName = (SELECT TeamName FROM TEAM WHERE TeamID = @TeamID)
SET @RoleName = (SELECT RoleName FROM [ROLE] WHERE RoleID = @RoleID)
SET @ActionName = (SELECT ActionName FROM [ACTION] WHERE ActionID = @ActionID)
SET @TaskName = (SELECT TaskName FROM TASK WHERE TaskID = @TaskID)
SET @Points = (@Rand * 10)
SET @UTRATBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 10, GETDATE()))
WHILE @UTRATBeginDate < @UTRBeginDate
BEGIN
SET @Rand = (SELECT RAND())
SET @UTRATBeginDate = (SELECT DATEADD(MONTH, - @Rand * 1000 - 10, GETDATE()))
END
SET @UTRATDueDate = (SELECT DATEADD(MONTH, - @Rand * 1000, GETDATE()))
WHILE @UTRATDueDate < @UTRATBeginDate
BEGIN
SET @Rand = (SELECT RAND())
SET @UTRATDueDate = (SELECT DATEADD(MONTH, - @Rand * 1000, GETDATE()))
END
EXEC usp_USER_TEAM_ROLE_ACTION_TASK
@eMail = @eMail,
@TeamName = @TeamName,
@RoleName = @RoleName,
@ActionName = @ActionName,
@TaskName = @TaskName,
@UTRATBeginDate = @UTRATBeginDate,
@UTRATDueDate = @UTRATDueDate,
@Points = @Points
SET @RUN = @RUN - 1
END
GO

ALTER PROCEDURE Wrapper_Event_Acknowledgment
@RUN INT
AS 
DECLARE
@EventTypeName varchar(50),
@EventName varchar(50),
@EventCount INT,
@EventTypeCount INT = (SELECT COUNT(*) FROM EVENT_TYPE),
@EventTypeID INT,

@eMail1 VARCHAR(100),
@TeamName1 VARCHAR(50),
@RoleName1 VARCHAR(50),
@eMail2 VARCHAR(100),
@TeamName2 VARCHAR(50),
@RoleName2 VARCHAR(50),
@AckDate DATE,
@AckTime TIME,
@AckAmount NUMERIC(5,2),
@UserTeamRoleCount INT = (SELECT COUNT(*) FROM USER_TEAM_ROLE),
@UserTeamRole1ID INT = 0,
@UserTeamRole2ID INT = 0,
@UserID INT,
@TeamID INT,
@RoleID INT,
@Rand NUMERIC(16,16)
WHILE @RUN > 0
BEGIN
SET @Rand = (SELECT RAND())
SET @EventCount = (SELECT COUNT(*) + 1 FROM EVENT) 
SET @EventTypeID = (@Rand * @EventTypeCount + 1)
SET @EventTypeName = (SELECT EventTypeName FROM EVENT_TYPE WHERE EventTypeID = @EventTypeID)
SET @EventName = 'Event' + CAST(@EventCount as varchar(50))
EXEC usp_EVENT
@EventTypeName = @EventTypeName,
@EventName = @EventName

SET @Rand = (SELECT RAND())
SET @UserTeamRole1ID = (@Rand * @UserTeamRoleCount + 1)
SET @UserID = (SELECT UserID FROM [USER_TEAM_ROLE] WHERE UserTeamRoleID = @UserTeamRole1ID)
SET @TeamID = (SELECT TeamID FROM [USER_TEAM_ROLE] WHERE UserTeamRoleID = @UserTeamRole1ID)
SET @RoleID = (SELECT RoleID FROM [USER_TEAM_ROLE] WHERE UserTeamRoleID = @UserTeamRole1ID)
SET @eMail1 = (SELECT eMail FROM [USER] WHERE UserID = @UserID)
SET @TeamName1 = (SELECT TeamName FROM TEAM WHERE TeamID = @TeamID)
SET @RoleName1 = (SELECT RoleName FROM [ROLE] WHERE RoleID = @RoleID)

SET @Rand = (SELECT RAND())
SET @UserTeamRole2ID = (@Rand * @UserTeamRoleCount + 1)
WHILE @UserTeamRole1ID = @UserTeamRole2ID
BEGIN
SET @Rand = (SELECT RAND())
SET @UserTeamRole2ID = (@Rand * @UserTeamRoleCount + 1)
END
SET @UserID = (SELECT UserID FROM [USER_TEAM_ROLE] WHERE UserTeamRoleID = @UserTeamRole2ID)
SET @TeamID = (SELECT TeamID FROM [USER_TEAM_ROLE] WHERE UserTeamRoleID = @UserTeamRole2ID)
SET @RoleID = (SELECT RoleID FROM [USER_TEAM_ROLE] WHERE UserTeamRoleID = @UserTeamRole2ID)
SET @eMail2 = (SELECT eMail FROM [USER] WHERE UserID = @UserID)
SET @TeamName2 = (SELECT TeamName FROM TEAM WHERE TeamID = @TeamID)
SET @RoleName2 = (SELECT RoleName FROM [ROLE] WHERE RoleID = @RoleID)

SET @AckDate = (SELECT DATEADD(DAY, -100 * @Rand, GETDATE()))
SET @AckTime = (SELECT GETDATE())
SET @AckAmount = (@Rand * 10)

EXEC usp_ACKNOWLEDGEMENT
@EventName = @EventName,
@eMail1 = @eMail1,
@TeamName1 = @TeamName1,
@RoleName1 = @RoleName1,
@eMail2 = @eMail2,
@TeamName2 = @TeamName2,
@RoleName2 = @RoleName2,
@AckDate = @AckDate,
@AckTime = @AckTime,
@AckAmount = @AckAmount

SET @RUN = @RUN - 1
END
GO

