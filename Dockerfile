# 1단계: Vue 앱 빌드
FROM node:18-alpine AS build
WORKDIR /app

# 종속성 설치
COPY package*.json ./
RUN npm install

# 전체 소스 복사 후 빌드
COPY . .
RUN npm run build

# 2단계: Nginx로 정적 파일 서빙
FROM nginx:alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html

# Vue 라우터가 history 모드일 경우에 대비한 Nginx 설정
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
