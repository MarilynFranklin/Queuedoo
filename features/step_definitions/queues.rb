Given "that line has two queuers" do
  line = Line.last
  Fabricate(:queuer, line: line, name: "John")
  Fabricate(:queuer, line: line, name: "Mary")
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
