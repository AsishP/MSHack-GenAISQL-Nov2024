-- Create tables for storing session data and embeddings
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'web.sessions')
BEGIN

CREATE SEQUENCE [web].[global_id] 
    AS [int]
    START WITH 1
    INCREMENT BY 1

-- Create the sessions table
CREATE TABLE [web].[sessions]
(
    [id] INT DEFAULT (NEXT VALUE FOR [web].[global_id]) NOT NULL,
    [title] NVARCHAR (200) NOT NULL,
    [abstract] NVARCHAR (MAX) NOT NULL,
    [external_id] VARCHAR (100) COLLATE Latin1_General_100_BIN2 NOT NULL,
    [details] JSON NULL,
    [require_embeddings_update] BIT DEFAULT ((0)) NOT NULL,

    PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([title] ASC)
);

ALTER TABLE [web].[sessions] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'web.sessions_details_embeddings')
BEGIN
-- Create the sessions_details_embeddings table
CREATE TABLE [web].[sessions_details_embeddings]
(
    [id] INT DEFAULT (NEXT VALUE FOR [web].[global_id]) NOT NULL,
    [session_id] INT NOT NULL,
    [details_vector_text3] VECTOR(1536) NOT NULL
)
CREATE CLUSTERED INDEX [ixc] ON [web].[sessions_details_embeddings]([session_id] ASC)
CREATE NONCLUSTERED INDEX [ix__review_id] ON [web].[sessions_details_embeddings] ([session_id] ASC, [id] ASC)
ALTER TABLE [web].[sessions_details_embeddings] ADD CONSTRAINT pk__sessions_details_embeddings PRIMARY KEY NONCLUSTERED ([id] ASC)
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'web.sessions_abstracts_embeddings')
BEGIN
-- Create the sessions_abstracts_embeddings table
CREATE TABLE [web].[sessions_abstracts_embeddings]
(
    [id] INT DEFAULT (NEXT VALUE FOR [web].[global_id]) NOT NULL,
    [session_id] INT NOT NULL,
    [abstract_vector_text3] vector(1536) not null
)
CREATE CLUSTERED INDEX [ixc] ON [web].[sessions_abstracts_embeddings]([session_id] ASC)
CREATE NONCLUSTERED INDEX [ix__review_id] ON [web].[sessions_abstracts_embeddings] ([session_id] ASC, [id] ASC)
ALTER TABLE [web].[sessions_abstracts_embeddings] ADD CONSTRAINT pk__sessions_abstracts_embeddings PRIMARY KEY NONCLUSTERED ([id] ASC)
END
GO
