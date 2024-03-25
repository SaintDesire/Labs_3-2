const DB_controller = require('../dataBase/DB');
const url = require('url');

class auditoriumsAPI {

    async select(req, res) {
        let response;
        let DB = new DB_controller();

        try {
            response = await DB.prismaClient.aUDITORIUM.findMany();
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }

        res.status(200).json(response);
    }

    async selectWithComp1(req, res) {
        let response;
        let DB = new DB_controller();
    
        try {
            response = await DB.prismaClient.aUDITORIUM.findMany({
                where: {
                    AND: [
                        {
                            AUDITORIUM: {
                                endsWith: "-1"
                            }
                        },
                        {
                            AUDITORIUM_TYPE: "ЛБ-К"
                        }
                    ]
                }
            });
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }

    async auditoriumsSameCount(req, res) {
        let response;
        let DB = new DB_controller();
    
        try {
            response = await DB.prismaClient.aUDITORIUM.groupBy({
                by: ['AUDITORIUM_TYPE', 'AUDITORIUM_CAPACITY'],
                _count: true // Подсчитывает количество аудиторий с одинаковым типом и вместимостью
            });
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
    async insert(req, res) {
        let prisma = new DB_controller().prismaClient;
        let response;
        const { AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE } = req.body;
    
        try {
            response = await prisma.aUDITORIUM.create({
                data: {
                    AUDITORIUM: AUDITORIUM,
                    AUDITORIUM_NAME: AUDITORIUM_NAME,
                    AUDITORIUM_CAPACITY: Number(AUDITORIUM_CAPACITY),
                    AUDITORIUM_TYPE: AUDITORIUM_TYPE
                }
            });
            response = { message: 'Insert successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to insert auditorium' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
    async update(req, res) {
        let prisma = new DB_controller().prismaClient;
        let response;
        const { AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE } = req.body;
    
        try {
            response = await prisma.aUDITORIUM.update({
                where: { AUDITORIUM: AUDITORIUM },
                data: {
                    AUDITORIUM_NAME: AUDITORIUM_NAME,
                    AUDITORIUM_CAPACITY: Number(AUDITORIUM_CAPACITY),
                    AUDITORIUM_TYPE: AUDITORIUM_TYPE
                }
            });
            response = { message: 'Update successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to update auditorium' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
    async delete(req, res) {
        let prisma = new DB_controller().prismaClient;

        let response;
        const { id } = req.params;
    
        try {
            response = await prisma.aUDITORIUM.delete({
                where: { AUDITORIUM: id }
            });
            response = { message: 'Delete successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to delete auditorium' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }

    async transaction(req, res) {
        let response;
        const db = new DB_controller();

        try {
            await db.prismaClient.$transaction(async (tx) => {
                // Изменяем вместимость всех аудиторий на 100 (используя инкремент)
                await tx.aUDITORIUM.updateMany({
                    data: {
                        AUDITORIUM_CAPACITY: {
                            increment: 100
                        }
                    }
                });

                // Получаем список всех аудиторий после обновления
                const auditoriums = await tx.aUDITORIUM.findMany();

                // Выводим номер и вместимость каждой аудитории
                auditoriums.forEach((auditorium) => {
                    console.log(
                        `Аудитория №${auditorium.AUDITORIUM}: Вместимость - ${auditorium.AUDITORIUM_CAPACITY}`
                    );
                });

                await new Promise(resolve => setTimeout(resolve, 2000));

                throw 'rollback transaction';
            }, {
                timeout: 1000
            });
        } catch (e) {
            console.log(e);
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(e));
            return;
        }

        res.status(200).json(response);
    }

}

module.exports = new auditoriumsAPI();