# TAA Logistics Server and CRM

## Specifications

The TAA Logistics Server is a Ruby on Rails application designed to manage logistics operations for TAA. It uses PostgreSQL for data storage. This serves as an API for the React Client as well.

### Requirements

- Ruby 2.7.0 or later
- Rails 6.0.0 or later
- PostgreSQL 12.0 or later

## Services

| name | description | env | price |
| ---  |   -----     | --- | ---   |
| **POSTMARK** | Used for sending emails | POSTMARK_API_TOKEN, MAILER_EMAIL| $0-$15 |
| **CLOUDINARY** | Used for image storage | CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET | free |
| **RENDER** | Used for hosting | ADMIN_PASSWORD, CORS_ORIGIN | $12 |
| **TWILIO** | Used for SMS | TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN | undefined |

## Meeting Notes

- Fix Junk Mail Issue

## New Features

### CRM

An issue we are currently facing is too much business, so we are looking to automate rates.

For legal weight, we are looking at this algorithm for line haul (LH)

`LH = 2 * distance * MKT`

Where LH is line haul, MKT is market average per mile and distance is the distance between ramp destinations

We add that with the fuel surcharge (FSCH)

`FSCH = (SCH% * LH) + LH`

Where SCH% is the surcharge based off the U.S. National Diesel Average. You can find the info [here](https://docs.google.com/spreadsheets/d/1w3quOQFzR_akIpolkxJCbTilG2C7c3Aa/edit?usp=sharing&ouid=111587941505182220372&rtpof=true&sd=true)

#### Flat Rates

##### Chassis/ Splits Charges

- Reg. Chassis: $40 per day
- Chassis Split: $85 per split
- Pre Pull: $150
- Yard Storage: $45 per day

##### For Exports, If No Billing or rail won’t accept the container after loaded by the customer the following charges will apply

- Rail Redelivery: $250
- Yard Storage: $45 per day
- Chassis: $40 per day

#### Outline for Website

1. Receive email from client
2. Take From and To
3. Get distance using GMAPS API and boolean for tolls
4. Store data for less API calls later on
5. Use the res to get LH and FSCH
6. Send notification to dispatch in the quotes email

#### Outline for Bids

1. Receive Bids Email
2. Upload CSV file for Bids
3. Get distances using GMAPS API and boolean for tolls
4. Iterate through bids and add column for distance, tolls, LH, FSCH, and Price
5. Store data for less API calls later on
6. Return Updated CSV downloadable to return quotes

#### Email Solution

Install and Configure Outlook:

Ensure Microsoft Outlook is installed on your client's computer.
Configure Outlook with the client’s email account using the appropriate settings (IMAP/POP).
Create a Local Archive Folder:

Open Outlook.
Go to File > Info > Tools > Clean Up Old Items.
Select Archive this folder and all subfolders.
Choose the main folder of the email account (usually the account name).
Set a date to archive emails older than a specified time (e.g., emails older than 6 months).
Choose a location on the local computer to save the archive file (.pst file).
Click OK to start the archiving process.
Accessing Archived Emails:

To access the archived emails, go to File > Open & Export > Open Outlook Data File.
Browse to the location where the .pst file was saved.
Select the .pst file and click OK.
The archived emails will appear in the Outlook folder list under a separate section (usually named "Archives" or the name of the .pst file).
Managing Archived Emails:

The archived emails can be accessed, searched, and managed just like regular emails in Outlook.
The client can open, reply to, forward, and organize archived emails without affecting the storage space on the email server.
Example Walkthrough
Step 1: Install and Configure Outlook

If not already done, download and install Microsoft Outlook.
Set up the client's email account using IMAP (preferred for syncing) or POP (downloads emails and deletes from the server).
Step 2: Create a Local Archive Folder

Open Outlook and go to the File tab.
Click Info, then Tools, and select Clean Up Old Items.
Choose Archive this folder and all subfolders.
Select the top-level folder of the email account.
Choose a date to archive emails older than (e.g., emails older than 6 months).
Specify the location to save the .pst file (e.g., C:\Users\[YourUsername]\Documents\Outlook Files\archive.pst).
Click OK to start the archiving process.
Step 3: Accessing Archived Emails

In Outlook, go to File > Open & Export > Open Outlook Data File.
Navigate to the location where the .pst file was saved and select it.
Click OK. The archived emails will appear in the folder list, usually under a section labeled "Archives."
Tips for Efficient Archiving
Regular Archiving: Set a regular schedule for archiving (e.g., every 6 months) to keep the mailbox manageable.
Backup Archives: Regularly back up the .pst files to an external drive or cloud storage to prevent data loss.
Folder Organization: Maintain a consistent folder structure within the archive for easy navigation and retrieval.
By following these steps, your client will have a seamless experience accessing their archived emails in Outlook without worrying about running out of email server storage.
