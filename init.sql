CREATE DATABASE MetaRiskCloud;
GO

USE [MetaRiskCloud];
GO

IF OBJECT_ID('dbo.ClientSearch', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.ClientSearch;
END
GO


CREATE TABLE [dbo].[ClientSearch](
	[UniqueId] [uniqueidentifier] NOT NULL,
	[CncEntityId] [int] NULL,
	[MdmId] [int] NULL,
	[AbnNumber] [nvarchar](max) NULL,
	[BackendSystem] [nvarchar](max) NOT NULL,
	[BackendSystemId] [int] NOT NULL,
	[CompanyType] [nvarchar](max) NULL,
	[DunsNumber] [float] NULL,
	[GcStatus] [nvarchar](max) NULL,
	[HierarchyLevel] [nvarchar](max) NULL,
	[LegalName] [nvarchar](max) NULL,
	[LegalStatus] [nvarchar](max) NULL,
	[RegionName] [nvarchar](max) NULL,
	[Score] [float] NULL,
	[ShortName] [nvarchar](max) NULL,
	[SpNumber] [float] NULL,
	[DisplayName] [nvarchar](max) NULL,
	[ConcurrencyToken] [timestamp] NULL,
 CONSTRAINT [PK_ClientSearch] PRIMARY KEY CLUSTERED 
(
	[UniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

IF OBJECT_ID('dbo.UserSearch', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.UserSearch;
END
GO

CREATE TABLE [dbo].[UserSearch](
	[UniqueId] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[DisplayName] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[SupervisorName] [nvarchar](max) NULL,
	[SupervisorId] [int] NULL,
	[BackendSystem] [nvarchar](max) NULL,
	[EmployeeId] [int] NOT NULL,
	[EmploymentStatus] [nvarchar](max) NULL,
	[Location] [nvarchar](max) NULL,
	[LocationDescription] [nvarchar](max) NULL,
	[LocationRegion] [nvarchar](max) NULL,
	[GCFunction] [nvarchar](max) NULL,
	[MMCBusinessUnitDescription] [nvarchar](max) NULL,
	[Score] [float] NULL,
	[ConcurrencyToken] [timestamp] NULL,
 CONSTRAINT [PK_UserSearch] PRIMARY KEY CLUSTERED 
(
	[UniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
