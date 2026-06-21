# Minimal, secure Node.js Dockerfile for production
########################################
# Builder stage: install deps + optional build
########################################
FROM node:18-alpine AS builder
WORKDIR /usr/src/app

# Install dependencies (use lockfile if present for reproducible builds)
COPY package*.json ./
RUN if [ -f package-lock.json ]; then \
			npm ci; \
		elif [ -f package.json ]; then \
			npm install; \
		else \
			echo "No package.json found, skipping npm install"; \
		fi

# Copy source and run build if script exists
COPY . .
RUN if [ -f package.json ] && grep -q "\"build\"" package.json 2>/dev/null; then \
			npm run build; \
		else echo "No build script, skipping"; fi


########################################
# Runner stage: production image
########################################
FROM node:18-alpine AS runner
WORKDIR /usr/src/app

# Copy only what we need from builder: package metadata, node_modules, and built/source files
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app .

# Drop root privileges where possible
RUN if id node >/dev/null 2>&1; then chown -R node:node /usr/src/app; fi
USER node

ENV NODE_ENV=production
EXPOSE 3000

# Healthcheck (optional; adjust path as needed)
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD wget -qO- http://localhost:3000/ || exit 1

CMD ["node","index.js"]