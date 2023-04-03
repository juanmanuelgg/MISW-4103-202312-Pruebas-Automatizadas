import express from "express";
import cors from "cors";

const app = express();

const PORT = process.env.PROTO_PORT || 5000;

app.get("/", (req, res) => {
  const ipVisitante = req.socket.remoteAddress;
  const { cookie } = req.query;

  console.log(`ip: ${ipVisitante}, cookie: ${cookie}`);

  res.status(200).send("OK");
});

app.use(cors({ origin: "*" }));

app.listen(PORT, () => {
  console.log(
    `Autenticador proto-token ejecutandose en el puerto ${PORT} (http://localhost:${PORT}/)`
  );
});
