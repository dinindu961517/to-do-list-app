package lk.ijse.dep10.todo.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/tasks/")

public class TaskServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            super.doGet(req,resp);
        } else if (action.equalsIgnoreCase("delete")) {
            doDelete(req, resp);
        } else if (action.equalsIgnoreCase("update")) {
            doPatch(req,resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getPathInfo() != null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "invalid URI");
            return;
        }

        String description = req.getParameter("description");
        if (description ==null || description.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Description required");
            return;
        }

        BasicDataSource dbcp = (BasicDataSource) getServletContext().getAttribute("dbcp");
        try (Connection connection = dbcp.getConnection()) {
            PreparedStatement stm = connection.prepareStatement("INSERT INTO Task (description,status) VALUES (?, DEFAULT)");
            stm.setString(1, description);
            stm.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doDelete(req, resp);
    }

    protected void doPatch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    }
}
