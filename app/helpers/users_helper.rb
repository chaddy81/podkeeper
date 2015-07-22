module UsersHelper
  def last_discussion(pod)
    return @discussion if @discussion && @discussion.pod == pod
    @discussion = pod.notes.last
  end

  def active_discussion(pod)
    return @active_discussion if @active_pod == pod
    @active_pod = pod
    @active_discussion = pod.active_discussion
  end

end
