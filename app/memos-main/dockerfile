# ---------- Frontend build stage ----------
FROM node:18-alpine AS frontend-builder
WORKDIR /web

COPY ./web/package.json ./web/pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile

COPY ./web/ ./
RUN pnpm build    


# ---------- Backend build stage ----------
FROM golang:1.25-alpine AS backend-builder
WORKDIR /app

COPY ["go.mod","go.sum","./"]
RUN go mod download

COPY . .

RUN rm -rf server/router/frontend/dist && mkdir -p server/router/frontend/dist
COPY --from=frontend-builder /web/dist/ server/router/frontend/dist/

RUN CGO_ENABLED=0 GOOS=linux go build -o memos ./cmd/memos


# ---------- Runtime stage ----------
FROM alpine:3.19
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=backend-builder /app/memos .

RUN mkdir -p /var/opt/memos && chown -R appuser:appgroup /var/opt/memos

ENV MEMOS_MODE=prod \
   MEMOS_DATA=/var/opt/memos \
   MEMOS_PORT=5230

USER appuser

EXPOSE 5230

CMD ["./memos"]
