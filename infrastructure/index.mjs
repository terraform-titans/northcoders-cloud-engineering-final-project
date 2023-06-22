// Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
const ses = new SESClient({ region: "eu-west-2" });
export const handler = async(event) => {
  const recipientEmail = event.recipientEmail;
  const command1 = new SendEmailCommand({
    Destination: {
      ToAddresses: ["joshcstride@googlemail.com"],
    },
    Message: {
      Body: {
        Text: { Data: "New user " + recipientEmail + " has joined" },
      },
      Subject: { Data: "New User" },
    },
    Source: "joshcstride@googlemail.com",
  });
  const command2 = new SendEmailCommand({
    Destination: {
      ToAddresses: [recipientEmail],
    },
    Message: {
      Body: {
        Text: { Data: "Welcome " + recipientEmail + " to Northcoders!" },
      },
      Subject: { Data: "Welcome to Northcoders" },
    },
    Source: "joshcstride@googlemail.com",
  });
  try {
    let response1 = await ses.send(command1);
    let response2 = await ses.send(command2);
    // process data.
    return {response1, response2};
  }
  catch (error) {
    // error handling.
  }
  finally {
    // finally.
  }
};