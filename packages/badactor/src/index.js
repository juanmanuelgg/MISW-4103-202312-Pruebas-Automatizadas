import express from "express";
import cors from "cors";

const app = express();
app.use(cors({ origin: "*" }));

const PORT = process.env.PROTO_PORT || 5000;

app.get("/", (req, res) => {
  const ipVisitante = req.socket.remoteAddress;
  const { cookie } = req.query;

  console.log(`ip: ${ipVisitante}, cookie: ${cookie}`);

  res.send("OK");
});

app.listen(PORT, () => {
  console.log(
    `Autenticador proto-token ejecutandose en el puerto ${PORT} (http://localhost:${PORT}/)`
  );
});
