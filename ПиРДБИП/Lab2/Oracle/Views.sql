-- Просмотр списка кандидатов на вакансии
CREATE OR REPLACE VIEW CandidatesVacancyView AS
SELECT c.FullName AS CandidateName, v.Title AS VacancyTitle
FROM Candidates c
JOIN VacancyAnswers va ON c.CandidateID = va.CandidateID
JOIN Vacancies v ON va.VacancyID = v.VacancyID;


-- Просмотр результатов интервью
CREATE OR REPLACE VIEW InterviewResultsView AS
SELECT i.DateTime AS InterviewDateTime, i.Results, r.Criteria, r.Score, r.Comments
FROM Interviews i
JOIN Ratings r ON i.InterviewID = r.InterviewID;


-- Отчет о сотрудниках по отделам
CREATE OR REPLACE VIEW EmployeesByDepartmentsView AS
SELECT e.FullName AS EmployeeName, e.Position, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;


-- Просмотр активных вакансий
CREATE OR REPLACE VIEW ActiveVacanciesView AS
SELECT v.*
FROM Vacancies v
LEFT JOIN VacancyAnswers va ON v.VacancyID = va.VacancyID
WHERE va.VacancyID IS NULL;



SELECT * FROM CandidatesVacancyView;

SELECT * FROM InterviewResultsView;

SELECT * FROM EmployeesByDepartmentsView;

SELECT * FROM ActiveVacanciesView;