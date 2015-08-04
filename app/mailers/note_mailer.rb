class NoteMailer < ActionMailer::Base
  layout 'mailer'

  helper :application # for use in mailer views
  include ApplicationHelper # for use in mailer

  def urgent_note_posted(user, note)
    @user = user
    @note = note
    @email = user.email
    @twolines = true
    mail to: "#{user.full_name} <#{user.email}>",
         subject: "Urgent Discussion - #{@note.pod.name}",
         template_name: 'note_posted',
         reply_to: "Reply with a Comment <discussion-#{note.token}@#{Settings['griddler']['domain']}>",
         from: "#{note.user.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def note_posted(user, note)
    @user = user
    @email = user.email
    @note = note
    @twolines = true
    if @user.class.to_s == "User"
      reply = "Reply with a Comment <discussion-#{note.token}@#{Settings['griddler']['domain']}>"
    else
      reply = "Reply to User <#{@note.user.email}>"
    end
    mail to: "#{user.full_name} <#{user.email}>",
         subject: "Discussion - #{@note.pod.name}",
         reply_to: reply,
         from: "#{note.user.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def reply_to_my_note(user, comment)
    @comment = comment
    @user = user
    @email = @user.email
    @twolines = true
    unless comment.user.nil?
      from = comment.user.full_name
    else
      from = comment.invite.full_name
    end

    if @user.class.to_s == "User"
      reply = "Reply with a Comment <discussion-#{comment.note.token}@#{Settings['griddler']['domain']}>"
    else
      reply = "Reply to User <#{@comment.note.user.email}>"
    end
    subject = "#{'Urgent ' if @comment.note.is_urgent?}Discussion - #{@comment.note.pod.name}"
    mail to: "#{@user.full_name} <#{@user.email}>",
         subject: subject,
         reply_to: reply,
         from: "#{from} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def urgent_note_posted_to_non_member(invite, note)
    @note = note
    @email = invite.email
    @user = invite
    @twolines = true
    mail to: invite.email,
         subject: "Urgent Discussion - #{@note.pod.name}",
         template_name: 'note_posted',
         reply_to: note.user.email,
         from: "#{note.user.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def new_site_comment(site_comment)
    @site_comment = site_comment
    @email = 'podfeedback@podkeeper.com'
    recipients = ['steven@podkeeper.com', 'nikki@podkeeper.com']
    mail to: recipients,
         from: 'info@email.podkeeper.com'
  end

end