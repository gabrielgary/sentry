import axios from "axios";

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || "http://localhost:3000/api",
  headers: { "Content-Type": "application/json" }
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem("accessToken");
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

export const studentsApi = {
  list: () => api.get("/students"),
  create: (data) => api.post("/students", data),
  update: (id, data) => api.put(`/students/${id}`, data),
  remove: (id) => api.delete(`/students/${id}`)
};

export const employeesApi = {
  list: () => api.get("/employees"),
  create: (data) => api.post("/employees", data)
};

export const enrollmentsApi = {
  list: () => api.get("/enrollments"),
  create: (data) => api.post("/enrollments", data)
};

export const gradesApi = {
  list: () => api.get("/grades"),
  create: (data) => api.post("/grades", data)
};

export const attendanceApi = {
  list: () => api.get("/attendance"),
  create: (data) => api.post("/attendance", data)
};

export const financeApi = {
  tips: () => api.get("/tips"),
  tipPayments: () => api.get("/payments/tips"),
  servicePayments: () => api.get("/payments/services")
};

export default api;
