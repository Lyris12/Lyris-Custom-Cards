--Yu Gi Oh! EVOLUTE Card Template: This is a Template for Level 5/Rank 3 or Below, Please do not Delete the parts where are labelled as "Do not remove".
--If You wish a non Effect Evolute Monster, just keep the Summoning function and undeletable ones.
--After reading this boring line, delete this comment or replace it with your Card's Name!

function c101010297.initial_effect(c)
--
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(101010297,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c101010297.con)
	e8:SetCost(c101010297.cost)
	e8:SetTarget(c101010297.sptg)
	e8:SetOperation(c101010297.spop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e9:SetDescription(aux.Stringid(101010297,2))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c101010297.con)
	e9:SetCost(c101010297.descost)
	e9:SetTarget(c101010297.destg)
	e9:SetOperation(c101010297.desop)
	c:RegisterEffect(e9)
	if not c101010297.global_check then
		c101010297.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010297.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010297.evolute=true
c101010297.material1=function(mc) return mc:IsCode(74677422) and mc:IsFaceup() end
c101010297.material2=function(mc) return mc:GetLevel()==1 and mc:IsFaceup() end
function c101010297.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
end
function c101010297.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c101010297.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function c101010297.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010297.filter,tp,LOCATION_REMOVED+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_HAND)
end
function c101010297.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010297.filter,tp,LOCATION_REMOVED+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010297.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function c101010297.desfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsDestructable()
end
function c101010297.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010297.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010297.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010297.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local d=g:GetFirst()
	local atk=0
	if d:IsFaceup() then atk=d:GetAttack() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c101010297.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local atk=0
		if tc:IsFaceup() then atk=tc:GetAttack() end
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
