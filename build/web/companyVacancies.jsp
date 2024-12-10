<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.classes.DBConnector"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.classes.company" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%

    company company = (company) session.getAttribute("company");

    if (company != null) {
      
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Vacancies</title>
        <link rel="stylesheet" type="text/css" href="css/stylesheet.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <!--        <link href="css/bootstrap.min.css" rel="stylesheet">	-->
        <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
    </head>
    <body>
        <header id="header">

            <nav class="navbar navbar-expand-lg navbar-light">
                <div class="container-fluid">

                    <a class="navbar-brand" href="index.jsp">
                     
                        <img src="images/trendhireLogo.png" class="main-logo" alt="Logo" title="Logo" style="max-width: 150px; max-height: 100px;">

                    </a>

                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav navbar-center m-auto">
                            <li class="nav-item active">
                                <a class="nav-link" href="index.jsp">Home </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="vacancies.jsp">Vacancies</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="aboutUs.jsp">About Us</a>
                            </li>

                            <li class="nav-item">
                                <a class="nav-link" href="contact.jsp">Contact</a>
                            </li>
                        </ul>

                        <ul class="navbar-nav navbar-right">

                            <li><a class="btn btn-danger" href="./backend/logout.jsp">Log Out</a></li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>

        <section class="nearJob">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-5 nearcol">
                        <h1><i>"Your dream Employee</i></h1>
                        <h2 class="text-red"><i>Is Near to You"</i></h2>
                    </div>
                    <div class="col-sm-7 d-none d-md-block">
                        <div class="row">
                            <div class="d-flex w-100">
                                <img class="w-100" src="images/trendhireLogo.png" alt="Banner" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>


        <section class="profileMain">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-3 pe-lg-5">
                        <div class="card mb-2 border-0">
                            <div class="jobImage">
                                <div class="image-card">

                                    <img class="card-img-top" src="<% out.print(company.getCompanyPicture()); %>" alt="Profile">


                                </div>
                            </div>

                        </div>



                        <div class="proLinks">

                            <div class="d-grid mb-4">
                                <a href="companyProfile.jsp" class="btn btn-outline-danger">
                                    <i class="fa fa-user me-2" aria-hidden="true"></i> Profile
                                </a>
                            </div>
                            <div class="d-grid mb-4">
                                <a href="companyApplication.jsp" class="btn btn-outline-danger">
                                    <i class="fa-solid fa-address-card" aria-hidden="true"></i> Received Application

                                </a> 
                            </div>

                            <div class="d-grid mb-4">
                                <a href="./backend/logout.jsp" class="btn btn-outline-danger">
                                    <i class="fa fa-sign-out me-2" aria-hidden="true"></i> Logout
                                </a>
                            </div>
                        </div>
                    </div><!-- /. grid column -->

                    <div class="col-sm-9 profile_right">
                        <div class="border p-4">
                            <div class="row">
                                <div class="col-12">

                                    <div class="pb-5">
                                        <h3>Posted Vacancies</h3>
                                        <%    String requestMethod = request.getMethod();

                                            if ("GET".equals(requestMethod)) {
                                                String success = request.getParameter("success");
                                                if (success != null && success.equals("1")) {
                                        %>
                                        <div class='alert alert-success alert-dismissible fade show' role='alert'>
                                            Vacancy Deleted Successfully!
                                            <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                        </div>
                                        <%  }
                                            if (success != null && success.equals("0")) {  %>
                                        <div class='alert alert-danger alert-dismissible fade show' role='alert'>
                                            Vacancy Delete Failed!
                                            <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                        </div>
                                        <%  }

                                            }
                                        %>
                                        <span class="float-end fx-top">

                                            <a href="postvacancy.jsp" class="btn btn-danger">
                                                <i class="fa fa-edit me-2" aria-hidden="true"></i> Create New Vacancy
                                            </a>
                                        </span>

                                    </div>

                                    <%
                                        int currentPage = (request.getParameter("page") != null) ? Integer.parseInt(request.getParameter("page")) : 1;
                                        int recordsPerPage = 8; // Number of records to display per page

                                        Connection connection = DBConnector.getCon();
                                        PreparedStatement statement = null;
                                        ResultSet resultSet = null;

                                        try {
                                            int totalRecords = 0;
                                            int totalPages = 0;

                                            String countQuery = "SELECT COUNT(*) AS total FROM vacancy WHERE companyID = ?";
                                            PreparedStatement countStatement = connection.prepareStatement(countQuery);
                                            countStatement.setString(1, company.getCompanyID());
                                            ResultSet countResultSet = countStatement.executeQuery();
                                            if (countResultSet.next()) {
                                                totalRecords = countResultSet.getInt("total");
                                            }
                                            countResultSet.close();
                                            countStatement.close();

                                            totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

                                            int startIndex = (currentPage - 1) * recordsPerPage;
                                            String query = "SELECT * FROM vacancy WHERE companyID = ? ORDER BY vacancyID DESC LIMIT ?, ?";
                                            statement = connection.prepareStatement(query);
                                            statement.setString(1, company.getCompanyID());
                                            statement.setInt(2, startIndex);
                                            statement.setInt(3, recordsPerPage);
                                            resultSet = statement.executeQuery();

                                    %>
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead class="thead-light">




                                                <tr>
                                                    <th><b>Post Id</b></th>
                                                    <th scope="col"><b>Title</b></th>
                                                    <th scope="col"><b>Category</b></th>
                                                    <th scope="col"><b>Location</b></th>
                                                    <th scope="col"><b>Type</b></th>
                                                    <th scope="col"><b>Salary</b></th>
                                                    <th scope="col"><b>Delete</b></th>
                                                </tr>
                                            </thead>
                                            <tbody class="customtable">
                                                <%  while (resultSet.next()) {
                                                        String vacancyId = resultSet.getString("vacancyID");
                                                        String title = resultSet.getString("title");
                                                        String category = resultSet.getString("category");
                                                        String location = resultSet.getString("location");
                                                        String type = resultSet.getString("type");
                                                        String salary = resultSet.getString("salary");
                                                        String modalId = "profilModal" + vacancyId;

                                                        out.println("<tr>");
                                                        out.println("<td>" + vacancyId + "</td>");
                                                        out.println("<td>" + title + "</td>");
                                                        out.println("<td>" + category + "</td>");
                                                        out.println("<td>" + location + "</td>");
                                                        out.println("<td>" + type + "</td>");
                                                        out.println("<td>Rs." + salary + "</td>");
                                                %>
                                            <td>
                                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#<%= modalId%>">
                                                    Delete
                                                </button>


                                            </td>

                                            <form action="./backend/delete.jsp" method="post">

                                                <div class="modal fade shadow my-5" id="<%= modalId%>" tabindex="-1"
                                                     aria-labelledby="exampleModalLabel" aria-hidden="true" data-bs-backdrop="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">


                                                            <div class="modal-header">
                                                                <h1 class="modal-title fs-5" id="exampleModalLabel">Delete Vacancy</h1>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                                        aria-label="Close"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <input class="form-control" type="hidden" name="userID"
                                                                       value="">

                                                                <label for="formFile" class="form-label fs-5">Are you sure to delete this vacancy?  </label>


                                                                <input type="hidden" name="vacancyID" value="<% out.print(vacancyId); %>">

                                                            </div>
                                                            <div class="modal-footer">
                                                                <div class="input-group">

                                                                    <button class="btn btn-danger w-100" type="submit"
                                                                            id="inputGroupFileAddon04">Delete</button>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                </div>

                                            </form>   

                                            <%
                                                    out.println("</tr>");
                                                }
                                            %>

                                            </tbody>
                                        </table>




                                        <div class="row">
                                            <div class="col-md-6 align-self-center">
                                                <p id="dataTable_info" class="dataTables_info" role="status" aria-live="polite">
                                                    Showing <%= Math.min(totalRecords, startIndex + 1)%> to <%= Math.min(totalRecords, startIndex + recordsPerPage)%> of <%= totalRecords%>
                                                </p>
                                            </div>

                                            <div class="col-md-6">
                                                <nav class="d-lg-flex justify-content-lg-end dataTables_paginate paging_simple_numbers">
                                                    <ul class="pagination">
                                                        <% if (startIndex > 0) {%>
                                                        <li class="page-item"><a class="page-link" href="?page=<%= currentPage - 1%>">Previous</a></li>
                                                            <% } else { %>
                                                        <li class="page-item disabled"><span class="page-link">Previous</span></li>
                                                            <% } %>

                                                        <% for (int i = 1; i <= totalPages; i++) {%>
                                                        <li class="page-item <%= (currentPage == i) ? "active" : ""%>">
                                                            <a class="page-link" href="?page=<%= i%>"><%= i%></a>
                                                        </li>
                                                        <% } %>

                                                        <% if (startIndex < (totalPages - 1) * recordsPerPage) {%>
                                                        <li class="page-item"><a class="page-link" href="?page=<%= currentPage + 1%>">Next</a></li>
                                                            <% } else { %>
                                                        <li class="page-item disabled"><span class="page-link">Next</span></li>
                                                            <% } %>
                                                    </ul>
                                                </nav>
                                            </div>
                                        </div>

                                        <%
                                            } catch (SQLException ex) {
                                                ex.printStackTrace();
                                            } finally {
                                                if (resultSet != null) {
                                                    resultSet.close();
                                                }
                                                if (statement != null) {
                                                    statement.close();
                                                }
                                                if (connection != null) {
                                                    connection.close();
                                                }
                                            }
                                        %>
                                    </div>


                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

    </body>
</html>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
crossorigin="anonymous"></script>

<script>
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
</script>

<%
    } else {
        response.sendRedirect("companyLogin.jsp?error=2");
    }
%>