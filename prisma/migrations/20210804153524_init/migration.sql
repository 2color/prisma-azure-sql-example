BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[User] (
    [id] INT NOT NULL IDENTITY(1,1),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [DF__User__createdAt] DEFAULT CURRENT_TIMESTAMP,
    [email] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000),
    CONSTRAINT [PK__User__id] PRIMARY KEY ([id]),
    CONSTRAINT [User_email_unique] UNIQUE ([email])
);

-- CreateTable
CREATE TABLE [dbo].[Post] (
    [id] INT NOT NULL IDENTITY(1,1),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [DF__Post__createdAt] DEFAULT CURRENT_TIMESTAMP,
    [title] NVARCHAR(1000) NOT NULL,
    [content] NVARCHAR(1000),
    [published] BIT NOT NULL CONSTRAINT [DF__Post__published] DEFAULT 0,
    [authorId] INT NOT NULL,
    CONSTRAINT [PK__Post__id] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Comment] (
    [id] INT NOT NULL IDENTITY(1,1),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [DF__Comment__createdAt] DEFAULT CURRENT_TIMESTAMP,
    [comment] NVARCHAR(1000) NOT NULL,
    [writtenById] INT NOT NULL,
    [postId] INT NOT NULL,
    CONSTRAINT [PK__Comment__id] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Tag] (
    [id] INT NOT NULL IDENTITY(1,1),
    [tag] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [PK__Tag__id] PRIMARY KEY ([id]),
    CONSTRAINT [Tag_tag_unique] UNIQUE ([tag])
);

-- CreateTable
CREATE TABLE [dbo].[_TagToPost] (
    [A] INT NOT NULL,
    [B] INT NOT NULL,
    CONSTRAINT [_TagToPost_AB_unique] UNIQUE ([A],[B])
);

-- CreateIndex
CREATE INDEX [_TagToPost_B_index] ON [dbo].[_TagToPost]([B]);

-- AddForeignKey
ALTER TABLE [dbo].[Post] ADD CONSTRAINT [FK__Post__authorId] FOREIGN KEY ([authorId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Comment] ADD CONSTRAINT [FK__Comment__writtenById] FOREIGN KEY ([writtenById]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Comment] ADD CONSTRAINT [FK__Comment__postId] FOREIGN KEY ([postId]) REFERENCES [dbo].[Post]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[_TagToPost] ADD CONSTRAINT [FK___TagToPost__A] FOREIGN KEY ([A]) REFERENCES [dbo].[Post]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[_TagToPost] ADD CONSTRAINT [FK___TagToPost__B] FOREIGN KEY ([B]) REFERENCES [dbo].[Tag]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN 
    ROLLBACK TRAN;
END;
THROW

END CATCH
