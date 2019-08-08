
CREATE PROCEDURE find_UserTypeID
@UserTypeName varchar(50),
@UserTypeID INT OUTPUT
AS
SET @UserTypeID = (SELECT UserTypeID FROM USER_TYPE WHERE UserTypeName = @UserTypeName)
GO

CREATE PROCEDURE usp_USER
@UserTypeName varchar(50),
@UserBeginDate DATE,
@FirstName varchar(50),
@LastName varchar(50),
@BirthDate DATE,
@eMail varchar(100)
AS
DECLARE @UserTypeID INT
EXEC find_UserTypeID
@UserTypeName = @UserTypeName,
@UserTypeID = @UserTypeID OUTPUT
IF @UserTypeID IS NULL
BEGIN
RAISERROR ('@UserTypeID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO dbo.[USER](FirstName, LastName, BirthDate, eMail, UserBeginDate, UserTypeID)
VALUES (@FirstName, @LastName, @BirthDate, @eMail, @UserBeginDate, @UserTypeID)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_UserID
@eMail varchar(100),
@UserID INT OUTPUT
AS
SET @UserID = (SELECT UserID FROM [USER] WHERE eMail = @eMail)
GO

CREATE PROCEDURE find_TeamTypeID
@TeamTypeName varchar(50),
@TeamTypeID INT OUTPUT
AS
SET @TeamTypeID = (SELECT TeamTypeID FROM TEAM_TYPE WHERE TeamTypeName = @TeamTypeName)
GO

CREATE PROCEDURE usp_Team 
@TeamName varchar(50),
@TeamBeginDate DATE,
@TeamTypeName varchar(50)
AS
DECLARE @TeamTypeID INT
EXEC find_TeamTypeID
@TeamTypeName = @TeamTypeName,
@TeamTypeID = @TeamTypeID OUTPUT
IF @TeamTypeID IS NULL
BEGIN
RAISERROR('@TeamTypeID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO TEAM (TeamName, TeamTypeID, TeamBeginDate)
VALUES(@TeamName, @TeamTypeID, @TeamBeginDate)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_TeamID
@TeamName varchar(50),
@TeamID INT OUTPUT
AS
SET @TeamID = (SELECT TeamID FROM TEAM WHERE TeamName = @TeamName)
GO

CREATE PROCEDURE find_RoleID
@RoleName varchar(50),
@RoleID INT OUTPUT
AS
SET @RoleID = (SELECT RoleID FROM ROLE WHERE RoleName = @RoleName)
GO


CREATE PROCEDURE usp_USER_TEAM_ROLE
@TeamName varchar(50),
@RoleName varchar(50),
@eMail varchar(100),
@UTRBeginDate DATE
As
DECLARE @RoleID INT
DECLARE @TeamID INT
DECLARE @UserID INT
EXEC find_RoleID
@RoleName = @RoleName,
@RoleID = @RoleID OUTPUT
IF @RoleID IS NULL
BEGIN
RAISERROR('@RoleID cannot be found', 11, 1)
RETURN
END
Exec find_TeamID
@TeamName = @TeamName,
@TeamID = @TeamID OUTPUT
IF @TeamID IS NULL
BEGIN
RAISERROR('@TeamID cannot be found', 11, 1)
RETURN
END
Exec find_UserID
@eMail = @eMail,
@UserID = @UserID OUTPUT
IF @UserID IS NULL
BEGIN
RAISERROR('@UserID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO USER_TEAM_ROLE(UserID, TeamID, RoleID, UTRBeginDate)
VALUES(@UserID, @TeamID, @RoleID, @UTRBeginDate)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO




CREATE PROCEDURE find_UserTeamRoleID
@TeamName varchar(50),
@RoleName varchar(50),
@eMail varchar(100),
@UserTeamRoleID INT OUTPUT
As
DECLARE @RoleID INT
DECLARE @TeamID INT
DECLARE @UserID INT
EXEC find_RoleID
@RoleName = @RoleName,
@RoleID = @RoleID OUTPUT
IF @RoleID IS NULL
BEGIN
RAISERROR('@RoleID cannot be found', 11, 1)
RETURN
END
Exec find_TeamID
@TeamName = @TeamName,
@TeamID = @TeamID OUTPUT
IF @TeamID IS NULL
BEGIN
RAISERROR('@TeamID cannot be found', 11, 1)
RETURN
END
Exec find_UserID
@eMail = @eMail,
@UserID = @UserID OUTPUT
IF @UserID IS NULL
BEGIN
RAISERROR('@UserID cannot be found', 11, 1)
RETURN
END
SET @UserTeamRoleID = (SELECT UserTeamRoleID FROM USER_TEAM_ROLE WHERE UserID = @UserID AND TeamID = @TeamID AND RoleID = @RoleID)
GO

CREATE PROCEDURE find_PrizeTypeID
@PrizeTypeName varchar(50),
@PrizeTypeID INT OUTPUT
AS
SET @PrizeTypeID = (SELECT PrizeTypeID FROM PRIZE_TYPE WHERE PrizeTypeName = @PrizeTypeName)
GO

CREATE PROCEDURE usp_PRIZE
@PrizeName varchar(50),
@PrizePoints numeric(5,0),
@PrizeTypeName varchar(50),
@PrizeDate DATE
AS
DECLARE @PrizeTypeID INT
EXEC find_PrizeTypeID
@PrizeTypeName = @PrizeTypeName,
@PrizeTypeID = @PrizeTypeID OUTPUT
IF @PrizeTypeID IS NULL
BEGIN
RAISERROR ('@PrizeTypeID', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO PRIZE (PrizeName, PrizeTypeID, PrizePoints, PrizeDate)
VALUES (@PrizeName, @PrizeTypeID, @PrizePoints, @PrizeDate)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_PrizeID
@PrizeName varchar(50),
@PrizeID INT OUTPUT
AS
SET @PrizeID = (SELECT PrizeID FROM PRIZE WHERE PrizeName = @PrizeName)
GO

CREATE PROCEDURE usp_REDEMPTION
@RedemptionName VARCHAR(50),
@RedemptionDate DATE,
@PrizeName varchar(50)
AS
DECLARE @PrizeID INT
EXEC find_PrizeID
@PrizeName = @PrizeName,
@PrizeID = @PrizeID OUTPUT
IF @PrizeID IS NULL
BEGIN
RAISERROR('@PrizeID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO REDEMPTION(PrizeID, RedemptionName, RedemptionDate)
VALUES(@PrizeID, @RedemptionName, @RedemptionDate)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_RedemptionID
@RedemptionName VARCHAR(50),
@RedemptionID INT OUTPUT
AS
SET @RedemptionID = (SELECT RedemptionID FROM REDEMPTION WHERE RedemptionName = @RedemptionName)
GO

CREATE PROCEDURE usp_USER_TEAM_ROLE_REDEMPTION
@TeamName varchar(50),
@RoleName varchar(50),
@eMail varchar(100),
@RedemptionName varchar(50)
AS 
DECLARE @UserTeamRoleID INT
DECLARE @RedemptionID INT
EXEC find_UserTeamRoleID
@TeamName = @TeamName,
@RoleName = @RoleName,
@eMail = @eMail,
@UserTeamRoleID = @UserTeamRoleID OUTPUT
IF @UserTeamRoleID IS NULL
BEGIN
RAISERROR('@UserTeamRoleID cannot be found', 11, 1)
RETURN
END
EXEC find_RedemptionID
@RedemptionName = @RedemptionName,
@RedemptionID = @RedemptionID OUTPUT
IF @RedemptionID IS NULL
BEGIN
RAISERROR('RedemptionID cannot be found', 11, 1)
RETURN 
END
BEGIN TRAN T1
INSERT INTO USER_TEAM_ROLE_REDEMPTION(UserTeamRoleID, RedemptionID)
VALUES(@UserTeamRoleID, @RedemptionID)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_ProjectTypeID
@ProjectTypeName varchar(50),
@ProjectTypeID INT OUTPUT
AS
SET @ProjectTypeID = (SELECT ProjectTypeID FROM PROJECT_TYPE WHERE ProjectTypeName = @ProjectTypeName)
GO

CREATE PROCEDURE find_InstitutionTypeID
@InstitutionTypeName varchar(50),
@InstitutionTypeID INT OUTPUT
AS
SET @InstitutionTypeID = (SELECT InstitutionTypeID FROM INSTITUTION_TYPE WHERE InstitutionTypeName = @InstitutionTypeName)
GO

CREATE PROCEDURE usp_INSTITUTION
@InstitutionTypeName varchar(50),
@InstitutionName VARCHAR(50),
@InstitutionBeginDate DATE
AS 
DECLARE @InstitutionTypeID INT 
EXEC find_InstitutionTypeID
@InstitutionTypeName = @InstitutionTypeName,
@InstitutionTypeID = @InstitutionTypeID OUTPUT
IF @InstitutionTypeID IS NULL
BEGIN 
RAISERROR('@InstitutionTypeID cannot be found', 11, 1)
RETURN
END 
BEGIN TRAN T1
INSERT INTO INSTITUTION(InstitutionTypeID, InstitutionName, InstitutionBeginDate)
VALUES(@InstitutionTypeID, @InstitutionName, @InstitutionBeginDate)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO


CREATE PROCEDURE find_InstitutionID
@InstitutionName VARCHAR(50),
@InstitutionID INT OUTPUT
AS 
SET @InstitutionID = (SELECT InstitutionID FROM INSTITUTION WHERE InstitutionName = @InstitutionName)
GO

CREATE PROCEDURE find_GroupTypeID
@GroupTypeName VARCHAR(50),
@GroupTypeID INT OUTPUT
AS 
SET @GroupTypeID = (SELECT GroupTypeID FROM GROUP_TYPE WHERE GroupTypeName = @GroupTypeName)
GO

CREATE PROCEDURE usp_GROUP
@InstitutionName VARCHAR(50),
@GroupTypeName VARCHAR(50),
@GroupName VARCHAR(50),
@GroupBeginDate DATE
AS 
DECLARE @GroupTypeID INT
DECLARE @InstitutionID INT
EXEC find_GroupTypeID 
@GroupTypeName = @GroupTypeName,
@GroupTypeID = @GroupTypeID OUTPUT
IF @GroupTypeID IS NULL
BEGIN
RAISERROR('@GroupTypeID cannot be found', 11, 1)
RETURN
END
EXEC find_InstitutionID
@InstitutionName = @InstitutionName,
@InstitutionID = @InstitutionID OUTPUT
IF @InstitutionID IS NULL
BEGIN 
RAISERROR('@InstitutionID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO [GROUP](GroupName, InstitutionID, GroupTypeID, GroupBeginDate)
VALUES(@GroupName, @InstitutionID, @GroupTypeID, @GroupBeginDate)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_GroupID
@GroupName VARCHAR(50),
@GroupID INT OUTPUT
AS 
SET @GroupID = (SELECT GroupID FROM [GROUP] WHERE GroupName = @GroupName)
GO

CREATE PROCEDURE usp_PROJECT
@ProjectName VARCHAR(50),
@ProjectTypeName VARCHAR(50),
@ProjectBeginDate DATE,
@GroupName VARCHAR(50)
AS
DECLARE @ProjectTypeID INT
DECLARE @GroupID INT
EXEC find_ProjectTypeID
@ProjectTypeName = @ProjectTypeName,
@ProjectTypeID = @ProjectTypeID OUTPUT
IF @ProjectTypeID IS NULL
BEGIN
RAISERROR('@ProjectTypeID cannot be found', 11, 1)
RETURN
END
EXEC find_GroupID
@GroupName = @GroupName,
@GroupID = @GroupID OUTPUT
IF @GroupID IS NULL
BEGIN
RAISERROR('@GroupID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO PROJECT(ProjectName, ProjectTypeID, ProjectBeginDate, GroupID)
VALUES(@ProjectName, @ProjectTypeID, @ProjectBeginDate, @GroupID)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_ProjectID
@ProjectName VARCHAR(50),
@ProjectID INT OUTPUT
AS
SET @ProjectID = (SELECT ProjectID FROM PROJECT WHERE ProjectName = @ProjectName)
GO


CREATE PROCEDURE usp_PROJECT_TEAM
@ProjectName VARCHAR(50),
@TeamName VARCHAR(50)
AS
DECLARE @ProjectID INT
DECLARE @TeamID INT
EXEC find_ProjectID
@ProjectName = @ProjectName,
@ProjectID = @ProjectID OUTPUT
If @ProjectID IS NULL
BEGIN
RAISERROR ('@ProjectID cannot be found', 11, 1)
RETURN 
END
EXEC find_TeamID 
@TeamName = @TeamName,
@TeamID = @TeamID OUTPUT
IF @TeamID IS NULL
BEGIN 
RAISERROR ('@TeamID cannot be found', 11, 1)
RETURN 
END
BEGIN TRAN T1
INSERT INTO PROJECT_TEAM(ProjectID, TeamID)
VALUES (@ProjectID,@TeamID)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE 
COMMIT TRAN T1
GO

CREATE PROCEDURE find_TaskTypeID
@TaskTypeName VARCHAR(50),
@TaskTypeID INT OUTPUT
AS 
SET @TaskTypeID = (SELECT TaskTypeID FROM TASK_TYPE WHERE TaskTypeName = @TaskTypeName)
GO

CREATE PROCEDURE usp_TASK
@TaskTypeName VARCHAR(50),
@TaskName VARCHAR(50)
AS
DECLARE @TaskTypeID INT
EXEC find_TaskTypeID
@TaskTypeName = @TaskTypeName,
@TaskTypeID = @TaskTypeID OUTPUT
IF @TaskTypeID IS NULL
BEGIN
RAISERROR('@TaskTypeID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO TASK(TaskName, TaskTypeID)
VALUES (@TaskName, @TaskTypeID)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_TaskID
@TaskName VARCHAR(50),
@TaskID INT OUTPUT
AS 
SET @TaskID = (SELECT TaskID FROM TASK WHERE TaskName = @TaskName)
GO

CREATE PROCEDURE usp_PROJECT_TASK
@ProjectName VARCHAR(50),
@TaskName VARCHAR(50),
@ProjectTaskDate DATE
AS
DECLARE @ProjectID INT
DECLARE @TaskID INT
EXEC find_ProjectID
@ProjectName = @ProjectName,
@ProjectID = @ProjectID OUTPUT
IF @ProjectID IS NULL
BEGIN
RAISERROR('@ProjectID cannot be found', 11, 1)
RETURN
END
EXEC find_TaskID
@TaskName = @TaskName,
@TaskID = @TaskID OUTPUT
IF @TaskID IS NULL
BEGIN
RAISERROR('@TaskID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO PROJECT_TASK(ProjectID, TaskID, ProjectTaskDate)
VALUES (@ProjectID, @TaskID, @ProjectTaskDate)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_ActionID
@ActionName VARCHAR(50),
@ActionID INT OUTPUT
AS
SET @ActionID = (SELECT ActionID FROM ACTION WHERE ActionName = @ActionName)
GO

CREATE PROCEDURE usp_USER_TEAM_ROLE_ACTION_TASK
@eMail VARCHAR(100),
@TeamName VARCHAR(50),
@RoleName VARCHAR(50),
@ActionName VARCHAR(50),
@TaskName VARCHAR(50),
@UTRATBeginDate DATE,
@UTRATDueDate DATE,
@Points Numeric(5,2)
AS
DECLARE @UserTeamRoleID INT
DECLARE @TaskID INT
DECLARE @ActionID INT
EXEC find_UserTeamRoleID
@eMail = @eMail,
@TeamName = @TeamName,
@RoleName = @RoleName,
@UserTeamRoleID = @UserTeamRoleID OUTPUT
IF @UserTeamRoleID IS NULL
BEGIN 
RAISERROR('@UserTeamRoleID cannot be found', 11, 1)
RETURN 
END
EXEC find_ActionID
@ActionName = @ActionName,
@ActionID = @ActionID OUTPUT
IF @ActionID IS NULL
BEGIN
RAISERROR('@ActionID cannot be found', 11, 1)
RETURN
END
EXEC find_TaskID
@TaskName = @TaskName,
@TaskID = @TaskID OUTPUT
IF @TaskID IS NULL
BEGIN
RAISERROR('@RoleID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO USER_TEAM_ROLE_ACTION_TASK(UserTeamRoleID, ActionID, TaskID,UTRATBeginDate, UTRATDueDate, Points)
VALUES(@UserTeamRoleID, @ActionID, @TaskID, @UTRATBeginDate, @UTRATDueDate, @Points)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_EventTypeID
@EventTypeName varchar(50),
@EventTypeID INT OUTPUT
AS
SET @EventTypeID = (SELECT EventTypeID FROM EVENT_TYPE WHERE EventTypeName = @EventTypeName)
GO

CREATE PROCEDURE usp_EVENT
@EventTypeName varchar(50),
@EventName varchar(50)
AS 
DECLARE @EventTypeID INT
EXEC find_EventTypeID
@EventTypeName = @EventTypeName,
@EventTypeID = @EventTypeID OUTPUT
IF @EventTypeID IS NULL
BEGIN
RAISERROR('@EventTypeID cannot be found', 11, 1)
RETURN 
END
BEGIN TRAN T1
INSERT INTO EVENT(EventName, EventTypeID)
VALUES(@EventName, @EventTypeID)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
GO

CREATE PROCEDURE find_EventID
@EventName varchar(50),
@EventID INT OUTPUT
AS
SET @EventID = (SELECT EventID FROM EVENT WHERE EventName = @EventName)
GO

CREATE PROCEDURE usp_ACKNOWLEDGEMENT
@EventName VARCHAR(50),
@eMail1 VARCHAR(100),
@TeamName1 VARCHAR(50),
@RoleName1 VARCHAR(50),
@eMail2 VARCHAR(100),
@TeamName2 VARCHAR(50),
@RoleName2 VARCHAR(50),
@AckDate DATE,
@AckTime TIME,
@AckAmount NUMERIC(5,2)
AS
DECLARE @EventID INT
DECLARE @RecipientID INT
DECLARE @DonorID INT
EXEC find_EventID
@EventName = @EventName,
@EventID = @EventID OUTPUT
IF @EventID IS NULL
BEGIN
RAISERROR('@EventID cannot be found', 11, 1)
RETURN
END
EXEC find_UserTeamRoleID
@eMail = @eMail1,
@TeamName = @TeamName1,
@RoleName = @RoleName1,
@UserTeamRoleID = @DonorID OUTPUT
IF @DonorID IS NULL
BEGIN
RAISERROR('@DonorID cannot be found', 11, 1)
RETURN
END
EXEC find_UserTeamRoleID
@eMail = @eMail2,
@TeamName = @TeamName2,
@RoleName = @RoleName2,
@UserTeamRoleID = @RecipientID OUTPUT
IF @RecipientID IS NULL
BEGIN
RAISERROR('@RecipientID cannot be found', 11, 1)
RETURN
END
BEGIN TRAN T1
INSERT INTO ACKNOWLEDGEMENT(EventID, RecipientID, DonorID, AckDate, AckTime, AckAmount)
VALUES(@EventID, @RecipientID, @DonorID, @AckDate, @AckTime, @AckAmount)
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE 
COMMIT TRAN T1
GO
