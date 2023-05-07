<%@ page import="java.util.ArrayList" %>
<%@ page import="lk.ijse.dep10.todo.mode.Task" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="org.apache.commons.dbcp2.BasicDataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.rmi.RemoteException" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%!
    private ArrayList<Task> getTaskList(ResultSet rst) throws SQLException{
        ArrayList<Task> taskList = new ArrayList<>();
        while (rst.next()) {
            int id = rst.getInt("id");
            String description = rst.getString("description");
            String status = rst.getString("status");
            taskList.add(new Task(id, description,Task.Status.valueOf(status)));
        }
        return taskList;
    }
%>

<%
    BasicDataSource dbcp = (BasicDataSource) application.getAttribute("dbcp");
    try (Connection connection = dbcp.getConnection()) {
        Statement stm = connection.createStatement();
        ResultSet rst = stm.executeQuery("SELECT * FROM Task WHERE status='NOT_COMPLETED'");
        ArrayList<Task> taskList = getTaskList(rst);
        rst = stm.executeQuery("SELECT * FROM Task WHERE status='COMPLETED'");
        ArrayList<Task> completedTaskList = getTaskList(rst);
        request.setAttribute("taskList", taskList);
        request.setAttribute("completedTaskList", completedTaskList);
    }catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>


<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>To-do List App</title>
    <link rel="stylesheet" href="css/reset.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Roboto+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;1,100;1,200;1,300;1,400;1,500;1,600;1,700&family=Schibsted+Grotesk:ital,wght@0,400;0,500;0,600;0,700;0,800;1,400;1,500;1,600;1,700;1,800&family=Ubuntu:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,500;1,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <h1>
            <span class="material-symbols-outlined">
                task_alt
            </span>
            To-do List App
        </h1>
        <form action="tasks" method="post" enctype="application/x-www-form-urlencoded">
            <input name="description" type="text" placeholder="Enter a new task (Eg. Finalize the UI)">
            <button>Add New Task</button>
        </form>
    </header>
    <main>
        <section id="tasks">
            <c:if test="${empty taskList and empty completedTaskList}">
                <div id="hint">Please add a new Task!</div>
            </c:if>
            <c:if test="${empty taskList and !empty completedTaskList}">
                <div id="hint">Hooray! No more tasks to complete</div>
            </c:if>
            <c:forEach var="task" items="${taskList}">
                <div class="task">
                    <a href="tasks/${task.id} ? action =update&status=COMPLETED">
                        <label>
                            <input type="checkbox">${task.description}
                        </label>
                    </a>
                    <a href="tasks/${task.id}?action=delete" title="Delete Task">
                        <span class="material-symbols-outlined">
                            delete
                      </span>
                    </a>
                </div>
            </c:forEach>
            <c:if test="${!empty completedTaskList}">
                <section id="completed-tasks">
                    <h2>Completed Tasks</h2>
                    <c:forEach var="task" items="${completedTaskList}">
                        <div class="task completed">
                            <a href="tasks/${task.id}?action=update&status=NOT_COMPLETED">
                                <label>
                                    <input checked type="checkbox"> ${task.description}
                                </label>
                            </a>
                            <a href="tasks/${task.id}?action=delete">
                              <span class="material-symbols-outlined">
                                delete
                              </span>
                            </a>
                        </div>
                    </c:forEach>
                </section>
            </c:if>
        </section>
    </main>
    <footer>
        Copyright &copy; 2023 DEP-10. All Rights Reserved.
    </footer>


</body>
</html>