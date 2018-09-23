USE [master]
GO
CREATE DATABASE [DBAUtils]
GO
USE [DBAUtils]
GO
/****** Object:  Table [dbo].[restore_database_staging]    Script Date: 9/23/2018 1:57:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[restore_database_staging](
	[SourceServer] [varchar](50) NULL,
	[TestServer] [varchar](50) NULL,
	[Database] [varchar](100) NULL,
	[FileExists] [bit] NULL,
	[Size] [bigint] NULL,
	[RestoreResult] [varchar](20) NULL,
	[DbccResult] [varchar](20) NULL,
	[RestoreStart] [datetime] NULL,
	[RestoreEnd] [datetime] NULL,
	[RestoreElapsed] [time](0) NULL,
	[DbccStart] [datetime] NULL,
	[DbccEnd] [datetime] NULL,
	[DbccElapsed] [time](0) NULL,
	[BackupDate] [varchar](max) NULL,
	[BackupFiles] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwrestore_database]    Script Date: 9/23/2018 1:57:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwrestore_database]
AS
SELECT SourceServer,
       TestServer,
       [Database],
       FileExists,
       Size,
       RestoreResult,
       DbccResult,
       RestoreStart,
       RestoreEnd,
       DATEPART(SECOND, RestoreElapsed) + 60 * DATEPART(MINUTE, RestoreElapsed) + 3600 * DATEPART(HOUR, RestoreElapsed) AS RestoreElapsed,
       DbccStart,
       DbccEnd,
       DATEPART(SECOND, DbccElapsed) + 60 * DATEPART(MINUTE, DbccElapsed) + 3600 * DATEPART(HOUR, DbccElapsed) AS DbccElapsed,
       BackupDate,
       BackupFiles FROM restore_database_staging
GO
