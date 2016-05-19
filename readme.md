# Project Mathematics

Outline of the eventual website
-------
The idea for the website, which will eventually have sibling mobile supporting apps - is that of a maths education website that wholly encompass all aspects of a student's need delivered in a consistent way.

The MVP will contain
-------
* A course that covers all topics for 11 plus maths exams.
* High quality video tutorials on each topic.
* Unlimited supply of online questions and detailed solutions (solutions given in stages following hints).
* Track student progress through the *course track*.  Each topic has a base level of difficulty a student must achieve in order to move onto topics for which the current topic is a prerequiste.
* An achievement system - yet to be decided (points? badges? levels?)
* For each student, on a given topic, the website generates questions on the same topic of higher level of difficulty based on what the student has completed already.
* Student profile and parent dashboard.
* Unlimited supply of computer generated worksheets based on the student's current level on any topic, together with detailed solution sheet, for if the student/parent wish to do handwritten practice.
* Unlimited supply of computer generated 11 plus practice papers based on the student's current level across all 11 plus topics, together with detailed solution sheet.

Post MVP course list (*these will definetely happen*)
-------
All additional course tracks will follow the same structure of the 11 plus course - videos, online questions, offline worksheets and practice paper.
* GCSE Maths course (mostly computer generated content)
* Maths problem solving course based on GCSE level of knowledge (non-generated problems)
* A-level Maths course (mostly computer generated content)
* A-level Further Maths course (mostly computer genenated content)

Post MVP feature ideas / wish-list (*not limited to these*)
-------
- *ebook* with printable worksheets and practice papers on any topic.  This can be a seperate product line.  The idea is that the contents of the website will more than serve function of current school text books and much more.
- *teacher* portal - allow teachers to set up teaching plans, so that the website generate content based on the teacher's teaching plans.  This is also a seperate product line.  This can also be extended for school usage.
- *one-to-one sessions* have tutors/teachers on the site giving either written comments on student's practice paper or online lesson to discuss the student's work.
- *weekly fun maths-jam* lead by a teacher of the site, live-streamed session (akin to twitch), dicuss an interesting problem with students.

*Ok before we get too carried away...here and now...*


# Outline of *this* repository

This repository contains the ruby-written maths content generation engine that will eventually power the website described above for maths learning for students between ages 8 - 18.  Currently making maths 11 plus (keystage 2) topics.

Structure
--------
Each *topic is a class* which implements the following public API (public methods):
```ruby
self.generate_question(parameters)  #parameter is a hash
# return hash => {question: question,solution: solution}
```
```ruby
self.latex(question)  #the argument is the returned hash from previous method
# return hash => {question_latex:question_latex,solution_latex:solution_latex}
```
The returned hash contains the latex string for the question and the latex string for the solutions.
