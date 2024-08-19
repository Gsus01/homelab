---
título: <% tp.file.title %>
fecha: <% tp.file.creation_date() %>
tags: [video, youtube]
---

<%*
// Solicitar al usuario el enlace de YouTube
const youtubeUrl = await tp.system.prompt("Pega el enlace del video de YouTube");

// Extraer el ID del video del enlace
const videoId = youtubeUrl.match(/(?:https?:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=)?(.+)/)[1];

// Función para obtener datos del video (simulada, ya que no podemos hacer peticiones reales)
async function getVideoData(videoId) {
  // En un escenario real, aquí harías una petición a la API de YouTube
  // Por ahora, simularemos algunos datos
  return {
    title: "Título del video (simulado)",
    channel: "Nombre del canal (simulado)",
    publishDate: "2024-06-30",
    duration: "10:00"
  };
}

const videoData = await getVideoData(videoId);
_%>

# <% videoData.title %>

## Información del video
- **Título**: <% videoData.title %>
- **Canal**: <% videoData.channel %>
- **Fecha de publicación**: <% videoData.publishDate %>
- **Duración**: <% videoData.duration %>
- **Enlace**: <% youtubeUrl %>

## Video
<iframe width="560" height="315" src="https://www.youtube.com/embed/<% videoId %>" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Resumen


## Notas clave
1. 
2. 
3. 

## Citas importantes
> 

## Reflexiones personales


## Acciones / Tareas
- [ ] 
- [ ] 
- [ ] 

---
Última edición: <% tp.file.last_modified_date() %>