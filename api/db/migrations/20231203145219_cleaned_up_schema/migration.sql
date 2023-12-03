/*
  Warnings:

  - You are about to drop the column `personId` on the `Pairing` table. All the data in the column will be lost.
  - You are about to drop the column `santaId` on the `Pairing` table. All the data in the column will be lost.
  - You are about to drop the `UserEventStatus` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[email]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `pairingPersonId` to the `Pairing` table without a default value. This is not possible if the table is not empty.
  - Added the required column `pairingSantaId` to the `Pairing` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Status" AS ENUM ('INVITED', 'DECLINED', 'ACCEPTED');

-- DropForeignKey
ALTER TABLE "Pairing" DROP CONSTRAINT "Pairing_personId_fkey";

-- DropForeignKey
ALTER TABLE "Pairing" DROP CONSTRAINT "Pairing_santaId_fkey";

-- DropForeignKey
ALTER TABLE "UserEventStatus" DROP CONSTRAINT "UserEventStatus_eventId_fkey";

-- DropForeignKey
ALTER TABLE "UserEventStatus" DROP CONSTRAINT "UserEventStatus_userId_fkey";

-- AlterTable
ALTER TABLE "Event" ALTER COLUMN "sendReminder" SET DEFAULT false,
ALTER COLUMN "createdAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
CREATE SEQUENCE pairing_id_seq;
ALTER TABLE "Pairing" DROP COLUMN "personId",
DROP COLUMN "santaId",
ADD COLUMN     "pairingPersonId" INTEGER NOT NULL,
ADD COLUMN     "pairingSantaId" INTEGER NOT NULL,
ALTER COLUMN "id" SET DEFAULT nextval('pairing_id_seq');
ALTER SEQUENCE pairing_id_seq OWNED BY "Pairing"."id";

-- AlterTable
CREATE SEQUENCE user_id_seq;
ALTER TABLE "User" ALTER COLUMN "id" SET DEFAULT nextval('user_id_seq'),
ALTER COLUMN "firstName" DROP NOT NULL,
ALTER COLUMN "lastName" DROP NOT NULL,
ALTER COLUMN "avatar" DROP NOT NULL,
ALTER COLUMN "role" SET DEFAULT 'USER';
ALTER SEQUENCE user_id_seq OWNED BY "User"."id";

-- AlterTable
CREATE SEQUENCE wishlist_id_seq;
ALTER TABLE "Wishlist" ALTER COLUMN "id" SET DEFAULT nextval('wishlist_id_seq'),
ALTER COLUMN "order" DROP NOT NULL,
ALTER COLUMN "siteImage" DROP NOT NULL,
ALTER COLUMN "siteTitle" DROP NOT NULL,
ALTER COLUMN "siteDescription" DROP NOT NULL;
ALTER SEQUENCE wishlist_id_seq OWNED BY "Wishlist"."id";

-- DropTable
DROP TABLE "UserEventStatus";

-- DropEnum
DROP TYPE "UserStatus";

-- CreateTable
CREATE TABLE "UserStatus" (
    "id" TEXT NOT NULL,
    "status" "Status" NOT NULL,
    "userId" INTEGER NOT NULL,
    "eventId" TEXT NOT NULL,

    CONSTRAINT "UserStatus_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "UserStatus" ADD CONSTRAINT "UserStatus_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserStatus" ADD CONSTRAINT "UserStatus_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pairing" ADD CONSTRAINT "Pairing_pairingSantaId_fkey" FOREIGN KEY ("pairingSantaId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pairing" ADD CONSTRAINT "Pairing_pairingPersonId_fkey" FOREIGN KEY ("pairingPersonId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
