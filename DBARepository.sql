USE [master]
GO
CREATE DATABASE [DBARepository]
GO
USE [DBARepository]
GO
/****** Object:  Table [dbo].[Applications]    Script Date: 9/23/2018 1:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Applications](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idServer] [int] NULL,
	[AppName] [varchar](100) NULL,
	[database] [varchar](100) NULL,
	[AppOwner] [varchar](256) NULL,
	[DBOwner] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServerOverview]    Script Date: 9/23/2018 1:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerOverview](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [varchar](50) NULL,
	[InstanceName] [varchar](50) NULL,
	[Version] [varchar](100) NULL,
	[Edition] [varchar](100) NULL,
	[ServicePack] [varchar](10) NULL,
	[CummulativeUpdate] [char](4) NULL,
	[AlwaysOnEnabled] [bit] NULL,
	[FailoverClusteringEnabled] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Servers]    Script Date: 9/23/2018 1:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Servers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [varchar](50) NULL,
	[Owners] [varchar](200) NULL,
	[IsActive] [bit] NULL,
	[SrvRole] [varchar](11) NULL,
	[Node1] [varchar](50) NULL,
	[Node2] [varchar](50) NULL,
	[TCPPort] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO