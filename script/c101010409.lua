--created & coded by Lyris
--青光神竜－サイバー・アイス・ドラゴン
function c101010409.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c101010409.ffilter),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101010409.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c101010409.sprcon)
	e2:SetOperation(c101010409.sprop)
	c:RegisterEffect(e2)
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--spsummon success
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c101010409.eqtg)
	e4:SetOperation(c101010409.eqop)
	c:RegisterEffect(e4)
	--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c101010409.matcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c101010409.ffilter(c)
	return c:IsSetCard(0x93) and c:IsRace(RACE_MACHINE)
end
function c101010409.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c101010409.spfilter1(c,tp,ft)
	if c:IsSetCard(0x93) and c:IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) then
			return Duel.IsExistingMatchingCard(c101010409.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
			else
			return Duel.IsExistingMatchingCard(c101010409.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
		end
	else return false end
end
function c101010409.spfilter2(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end
function c101010409.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c101010409.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,ft)
end
function c101010409.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010027,0))
	local g1=Duel.SelectMatchingCard(tp,c101010409.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,ft)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c101010409.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010027,1))
	if ft>0 or (tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)) then
		g2=g:Select(tp,1,1,nil)
		else
		g2=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
	end
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c101010409.matcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsSetCard,nil,0x93)
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetOriginalAttribute())
		tc=g:GetNext()
	end
	e:GetLabelObject():SetLabel(att)
end
function c101010409.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local group=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local code=0
	local tc=mg:GetFirst()
	while tc do
		group:RemoveCard(tc)
		tc=mg:GetNext()
	end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and group:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=group:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c101010409.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c101010409.eqlimit)
		tc:RegisterEffect(e1)
		if bit.band(ct,ATTRIBUTE_LIGHT)~=0 then
			--Destroy replace
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_EQUIP)
			e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
			--disable
			local e2=Effect.CreateEffect(c)
			e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
			e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e2:SetCode(EVENT_CHAINING)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCondition(c101010409.discon)
			e2:SetCost(c101010409.discost)
			e2:SetTarget(c101010409.distg)
			e2:SetOperation(c101010409.disop)
			c:RegisterEffect(e2)
		end
		if bit.band(ct,ATTRIBUTE_DARK)~=0 then
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end if atk>3000 then atk=3000 end
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e4:SetCode(EFFECT_UPDATE_ATTACK)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			e4:SetValue(atk)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_PIERCE)
			c:RegisterEffect(e5)
		end
	end
end
function c101010409.eqlimit(e,c)
	return e:GetOwner()==c
end
function c101010409.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and Duel.IsChainNegatable(ev)
end
function c101010409.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return not c:IsReason(REASON_REPLACE) and g:IsExists(Card.IsLocation,1,nil,LOCATION_SZONE)
	end
	local g=c:GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_SZONE)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c101010409.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010409.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=ev+1 then return end
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
