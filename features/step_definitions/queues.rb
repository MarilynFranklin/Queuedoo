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
