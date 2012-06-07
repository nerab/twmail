# twmail

`twmail` allows you to mail new tasks to your TaskWarrior inbox.

## Installation

    $ gem install twmail

## Usage

1. Install ruby and this gem
1. If you don't have a `~/.fetchmailrc` yet, copy `doc/fetchmailrc.sample` to `~/.fetchmailrc`
1. Edit `~/.fetchmailrc` and adjust mail account settings. If in doubt, consult the fetchmail documentation, e.g. by executing `man fetchmailconf` in a terminal.

## Motivation
I would like to add new tasks to my TaskWarrior inbox from remote places where I don't have immediate access to my personal TaskWarrior database; e.g. from my iPhone, from work (where I don't have access to my personal TaskWarrior installation) or from another computer. 

Using eMail for this looks like a great candidate:

1. I don't want to (or cannot) install TaskWarrior on all the places and machines where I would like to add tasks from. Sending a note as eMail is pretty much universally available. 
1. Many applications were not made for integration with TaskWarrior. But even the dumbest iPhone app can forward text or a URL via eMail.
1. eMail is asynchronous by design (fire and forget). Even if disconnected from the net, I can send eMail and the system will deliver it on the very next occassion.

What is missing from a TaskWarrior perspective right now is a way to add these mails to a TaskWarrior installation automatically.

## Architecture
The simplest solution I could come up with is this:

1. A dedicated email account is used to collect the tasks.
1. A script that imports all eMails as new tasks.

As a prerequisite, TaskWarrior is assumed to be installed and configured. With this architecture in place, the functionality is rather simple to implement:

  For each mail{
    Transaction{
      * Fetch mail from mailbox
      * Store mail as new task in Taskwarrior
      * Delete mail from mailbox
    }
  }

  As the word `Transaction` implies, the whole operation needs to be atomic per mail. No task must be added if fetching a mail went wrong, and no mail must be deleted if storing the task in TaskWarrior failed.

The solution presented here maintains a one-to-one relation between the INBOX of an mail account and the TaskWarrior database.

TODO Use fetchmail's daemon mode

## Components
Mail fetching is done with fetchmail, a proven solution available on all major Unices. It will be configured to use the `twmail` script as a mail delivery agent (mda), which means nothing more that fetchmail fetches the mail from the configured account and hands it over to our script. There is no further storage of the received mails except in TaskWarrior.

## Error Handling
TODO
* If the MDA returns non-zero, fetchmail will not assume the message to be processed and it will try again.
* Do we need a dead-letter queue for all mails fetched, but not successfully processed?

## Alternatives
One might think of more elaborate applications that do more clever things, but I wanted to create this solution with as few external dependencies as possible. Fetchmail is available on all t Unices, and who can afford to live without TaskWarrior anyway? I also played with the thought of a central tasks server that receives mail from services like CloudMailIn and auto-adds them to the server, but the result would not be much different (besides being more complex) to the solution presented here: No task will be fetched into TaskWarrior until the machine with the TaskWarrior database is online.

## Advanced Usage
Many more advanced use cases like filtering and routing can be implemented on the mail server side. There are plenty of user interfaces for routing eMails based on their subject, sender, body text, etc. The simplest way to integrate these features with `twmail` is to use IMAP folders. After all filtering and routing, each eMail must end up in a dedicated IMAP folder (by default, all tasks are fetched from the INBOX folder). `twmail` can then be configured to do different things depending on which IMAP folder a mail came from.

As an example, here is a simple way to route eMails to different projects in TaskWarrior, based on their subject line:

1. Set up a dedicated IMAP folder for every project you work on, e.g. "Build Bikeshed", "Reading List", "Get Rich Fast"
1. Configure the mail server to move every mail from INBOX to the
  1.1. "Build Bikeshed" folder if the mail subject contains "project:Bikeshed"
  1.1. "Reading List" folder if the mail subject contains "project:Reading"
  1.1. "Get Rich Fast" folder if the mail subject contains "project:GetRichFast"
1. Tell `twmail` to fetch mails from the "Build Bikeshed", "Reading List", and "Get Rich Fast" IMAP folders (in addition to the INBOX):

TODO Continue description ...

The approach chosen for `twmail` also addresses SPAM filtering. Handling that remains the responsibility of the mail server. Anything that makes it to the INBOX is treated as task.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
