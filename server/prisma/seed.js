const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  await prisma.movie.deleteMany();
  await prisma.movie.createMany({
    data: [
      { title: 'Arrival', year: 2016 },
      { title: 'Tenet', year: 2020 },
      { title: 'Dune', year: 2021 },
      { title: 'Interstellar', year: 2014 },
      { title: 'Ex Machina', year: 2014 },
      { title: 'The Martian', year: 2015 },
    ],
  });
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => {
    console.error(e);
    prisma.$disconnect();
    process.exit(1);
  });
