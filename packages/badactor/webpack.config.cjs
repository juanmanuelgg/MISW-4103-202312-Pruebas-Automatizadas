const path = require("path");
const CopyPlugin = require("copy-webpack-plugin");

module.exports = {
  target: "node",
  mode: "production",
  entry: "./src/index.js",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "badactor.cjs",
  },
  plugins: [
    new CopyPlugin({
      patterns: [{ from: "./scripts/", to: "./" }],
    }),
  ],
};
