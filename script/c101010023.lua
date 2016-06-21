--サイバー・キャット
local id,ref=GIR()
function ref.start(c)
--equip
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(ref.eqtg)
	e0:SetOperation(ref.eqop)
	c:RegisterEffect(e0)
	--Do Not Remove
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EFFECT_REMOVE_TYPE)
	e20:SetValue(TYPE_UNION)
	c:RegisterEffect(e20)
	--be material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(ref.matcon)
	e4:SetOperation(ref.matop)
	c:RegisterEffect(e4)
	--synlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(ref.synlimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(ref.spcon)
	e2:SetTarget(ref.sptg)
	e2:SetOperation(ref.spop)
	c:RegisterEffect(e2)
	--lvchange
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetCondition(ref.lvcon)
	e3:SetValue(3)
	c:RegisterEffect(e3)
end
function ref.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_MACHINE)
end
function ref.cfilter(c)
return c:IsFaceup() and c:GetCode()==70095154
end
function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
return eg:IsExists(ref.cfilter,1,nil)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if c:IsRelateToEffect(e) then
Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
end
function ref.lvfilter(c)
return c:IsFaceup() and c:GetCode()==70095154
end
function ref.lvcon(e)
return Duel.IsExistingMatchingCard(ref.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:GetCode()~=id
end
function ref.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function ref.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc,true)
		--Add Equip limit
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(ref.eqlimit)
		c:RegisterEffect(e2)
	end
end
function ref.eqlimit(e,c)
	return c:IsRace(RACE_MACHINE)
end
function ref.matcon(e)
	local c=e:GetHandler()
	local tc=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and tc and tc:GetReason()==REASON_MATERIAL+8442
end
function ref.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget():GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	ec:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(ref.hdcon)
	e3:SetOperation(ref.hdop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	ec:RegisterEffect(e3)
end
function ref.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then bc=Duel.GetAttackTarget() end
	return ev>=2500 and c==bc
end
function ref.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
