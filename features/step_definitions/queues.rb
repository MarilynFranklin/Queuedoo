Given "that line has two queuers" do
  line = Line.last
  Fabricate(:queuer, line: line, name: "John", phone: "+15555555555", user_id: 1)
  line.reload
  Fabricate(:queuer, line: line, name: "Mary", phone: "+16154444444", user_id: 1)
end

Then "I should see the queue in order" do
  queuers = Line.last.queuers

  queuers.each do |queuer|
    page.should have_content "#{queuer.place_in_line} #{queuer.name}"
  end
end

Then "I should see the queue reordered" do
  queuers = Line.last.unprocessed_queuers.reload
  i = 1
  queuers.each do |queuer|
    page.should have_content "#{i} #{queuer.name}"
    i += 1
  end
end

Then "I should see the first two queuers switch places" do
  queuers = Line.last.unprocessed_queuers
  page.should have_content "1 Mary"
  page.should have_content "2 John"
end
