// Yönergedeki demo kaynağını yerel, çevrimdışı katalog verisine dönüştürür.
import fs from 'node:fs/promises';
const source = 'https://wantapi.com';
const response = await fetch(`${source}/products.php`);
if (!response.ok) throw new Error(`Ürünler indirilemedi: ${response.status}`);
const payload = await response.json();
const descriptions = {
  Telefon: 'Günlük hayatınız, fotoğraflarınız ve sevdiğiniz uygulamalar için tasarlanmış bir telefon. Güçlü performansı ve özenli tasarımı bir arada keşfedin.',
  Bilgisayar: 'Üretmek, çalışmak ve yeni fikirler geliştirmek için güçlü bir yardımcı. Geniş ekranı ve sade tasarımıyla çalışma alanınızı tamamlar.',
  Tablet: 'Not almak, çizim yapmak ve içeriklerin keyfini çıkarmak için taşınabilir bir ekran. Yaratıcı fikirlerinize her yerde eşlik eder.',
  Saat: 'Günlük hareketlerinizi ve bildirimlerinizi bileğinizden takip edin. Aktif yaşamınıza eşlik eden kullanışlı bir aksesuar.',
  Ses: 'Müzik, podcast ve sevdiğiniz sesler için tasarlandı. Günlük dinleme deneyiminize özenli bir dokunuş.',
  Aksesuar: 'Dijital içeriklerle etkileşim kurmanın farklı bir yolunu keşfedin. Yenilikçi tasarım ve teknoloji bir arada.',
};
await fs.mkdir('assets/images', {recursive: true});
await fs.mkdir('assets/data', {recursive: true});
const products = [];
for (const item of payload.data) {
  const category = item.id <= 5 ? 'Telefon' : item.id <= 10 ? 'Bilgisayar' : item.id <= 13 ? 'Tablet' : item.id <= 15 ? 'Saat' : item.id === 16 ? 'Aksesuar' : 'Ses';
  const file = item.image.split('/').pop();
  const image = await fetch(item.image);
  if (!image.ok) throw new Error(`${file}: ${image.status}`);
  await fs.writeFile(`assets/images/${file}`, Buffer.from(await image.arrayBuffer()));
  products.push({id: item.id, name: item.name, category,
    tagline: {Telefon:'Her gün için daha fazlası.',Bilgisayar:'Fikirlerinize güç katın.',Tablet:'İlham, her zaman yanınızda.',Saat:'Günün ritmini yakalayın.',Ses:'Sesin güzel tarafı.',Aksesuar:'Yeni bir bakış açısı.'}[category],
    description: descriptions[category], price: Number(item.price.replace(/[^0-9.]/g,'')), currency: item.currency,
    image: `assets/images/${file}`, specs: item.specs, featured: [1,7,12,17,18,20].includes(item.id)});
}
const banner = await fetch(`${source}/assets/banner.png`);
if (!banner.ok) throw new Error(`Banner: ${banner.status}`);
await fs.writeFile('assets/images/banner.png', Buffer.from(await banner.arrayBuffer()));
await fs.writeFile('assets/data/products.json', JSON.stringify(products,null,2)+'\n');
await fs.writeFile('assets/SOURCES.md', '# Demo veri ve görseller\n\nKaynak: https://wantapi.com/products.php ve https://wantapi.com/assets/banner.png\n\nYönergede belirtilen eğitim kaynağından alınan 20 ürün ve görsel yerel olarak saklanır. Açıklamalar Türkçeye uyarlanmıştır. Fiyatlar kaynaktaki USD demo fiyatlarıdır; güncel satış teklifi değildir. Ürün adları ve markalar sahiplerine aittir. Apple ile bağlantılı değildir. İnternet çalışma sırasında gerekmez.\n');
console.log(`${products.length} ürün ve banner kaydedildi.`);
